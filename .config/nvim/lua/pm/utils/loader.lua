local M = {}

local files = require 'pm.utils.files'
local log = require 'pm.utils.vim_logger'

--- Safely loads and evaluates the keymaps.lua file
--- @param keymaps_path string Path to the keymaps file
--- @return boolean success Whether the keymaps were loaded successfully
function M.load_keymaps_file(keymaps_path)
  if not files.file_exists(keymaps_path) then
    log.warn_fmt('Keymaps file not found: %s', keymaps_path)
    return false
  end

  local ok, err = pcall(dofile, keymaps_path)
  if not ok then
    log.error_fmt('Failed to load keymaps file: %s - %s', keymaps_path, tostring(err))
    return false
  end

  log.info_fmt(
    'Successfully loaded keymaps from: %s',
    files.get_relative_path(keymaps_path, vim.fn.stdpath 'config')
  )
  return true
end

--- Loads all plugin files from the plugins directory
--- @param plugins_dir string Path to the plugins directory
--- @param options table|nil Optional configuration: {silent = false, filter = function}
--- @return table Results with successful and failed loads
function M.load_plugins_directory(plugins_dir, options)
  options = options or {}
  options.silent = options.silent or false

  -- Filter to exclude init.lua files and ensure we only process plugin files
  options.filter = function(filepath, result)
    local filename = files.get_basename(filepath)

    -- Skip init files
    if filename == 'init' then
      return false
    end

    -- Apply custom filter if provided
    if options.filter and not options.filter(filepath, result) then
      return false
    end

    return true
  end

  local results = files.load_lua_files_safe(plugins_dir, options)

  if results.success_count > 0 then
    log.info_fmt('Successfully loaded %d plugin files', results.success_count)
  end

  if results.failure_count > 0 then
    log.warn_fmt('Failed to load %d plugin files', results.failure_count)
  end

  return results
end

--- Converts a file path to a require-style module path
--- @param filepath string The full file path
--- @param base_dir string The base directory (e.g., lua directory)
--- @return string The module path for require()
function M.filepath_to_module(filepath, base_dir)
  local relative = files.get_relative_path(filepath, base_dir)
  local module = relative:gsub('/', '.'):gsub('%.lua$', '')
  return module
end

--- Loads plugins using require instead of dofile for better module handling
--- @param plugins_dir string Path to the plugins directory
--- @param options table|nil Optional configuration
--- @return table Results with successful and failed loads
function M.load_plugins_with_require(plugins_dir, options)
  options = options or {}

  local lua_files = files.get_lua_files(plugins_dir, true)
  local results = {
    successful = {},
    failed = {},
    total = 0,
    success_count = 0,
    failure_count = 0,
  }

  for _, filepath in ipairs(lua_files) do
    local filename = files.get_basename(filepath)

    -- Skip init files
    if filename ~= 'init' then
      results.total = results.total + 1

      -- Convert file path to module path
      local config_lua_dir = vim.fn.stdpath 'config' .. '/lua'
      local module_path = M.filepath_to_module(filepath, config_lua_dir)

      local ok, result = pcall(require, module_path)
      if ok then
        table.insert(results.successful, {
          filepath = filepath,
          result = result,
          module = module_path,
        })
        results.success_count = results.success_count + 1
      else
        table.insert(results.failed, {
          filepath = filepath,
          error = result,
          module = module_path,
        })
        results.failure_count = results.failure_count + 1

        if not options.silent then
          log.error_fmt('Failed to load plugin: %s - %s', module_path, tostring(result))
        end
      end
    end
  end

  return results
end

--- Loads a configuration module safely
--- @param module_name string Name of the module to load
--- @param method_name string|nil Method to call on the module (default: 'setup')
--- @return boolean success Whether the module was loaded and called successfully
function M.load_config_module(module_name, method_name)
  method_name = method_name or 'setup'

  local ok, module = pcall(require, module_name)
  if not ok then
    log.error_fmt('Failed to load config module: %s - %s', module_name, tostring(module))
    return false
  end

  if type(module[method_name]) == 'function' then
    local success, err = pcall(module[method_name])
    if not success then
      log.error_fmt('Failed to call %s.%s(): %s', module_name, method_name, tostring(err))
      return false
    end
    log.info_fmt('Successfully loaded and called %s.%s()', module_name, method_name)
    return true
  else
    log.warn_fmt('Module %s does not have method %s', module_name, method_name)
    return false
  end
end

--- Comprehensive initialization function that loads all config files in correct order
--- @param config table Configuration table with paths and module names
--- @return table Results of the initialization process
function M.initialize(config)
  local results = {
    options = { success = false, error = nil },
    keymaps = { success = false, error = nil },
    plugins = { successful = {}, failed = {}, total = 0 },
    auto_cmds = { success = false, error = nil },
    lsp_cfg = { success = false, error = nil },
  }

  -- Step 1: Load options first (required for leader key)
  if config.options_module then
    log.info 'Starting options initialization...'
    results.options.success = M.load_config_module(config.options_module, 'setup')
    if not results.options.success then
      results.options.error = 'Failed to load options module'
      log.error 'Options initialization failed'
    end
  end

  -- Step 2: Load keymaps
  log.info 'Starting keymaps initialization...'
  results.keymaps.success = M.load_keymaps_file(config.keymaps_path)

  if not results.keymaps.success then
    results.keymaps.error = 'Failed to load keymaps file'
    log.error 'Keymaps initialization failed'
  else
    log.info 'Keymaps initialization completed successfully'
  end

  -- Step 3: Load plugins
  log.info 'Starting plugins initialization...'
  results.plugins = M.load_plugins_with_require(config.plugins_dir, config.options or {})

  if results.plugins.success_count > 0 then
    log.info_fmt(
      'Plugins initialization completed: %d/%d successful',
      results.plugins.success_count,
      results.plugins.total
    )
  else
    log.warn 'No plugins were successfully loaded'
  end

  -- Step 4: Load autocmds
  if config.auto_cmds_module then
    log.info 'Starting autocmds initialization...'
    results.auto_cmds.success = M.load_config_module(config.auto_cmds_module, 'setup')
    if not results.auto_cmds.success then
      results.auto_cmds.error = 'Failed to load autocmds module'
      log.error 'Autocmds initialization failed'
    end
  end

  -- Step 5: Load LSP configuration
  if config.lsp_cfg_module then
    log.info 'Starting LSP initialization...'
    results.lsp_cfg.success = M.load_config_module(config.lsp_cfg_module, 'enable')
    if not results.lsp_cfg.success then
      results.lsp_cfg.error = 'Failed to load LSP configuration module'
      log.error 'LSP initialization failed'
    end
  end

  return results
end

--- Get detailed information about loaded files
--- @param directory string Directory to analyze
--- @return table Detailed information about Lua files
function M.analyze_directory(directory)
  local info = {
    total_files = 0,
    lua_files = 0,
    subdirectories = {},
    file_sizes = {},
    modification_times = {},
  }

  local lua_files = files.get_lua_files(directory, true)
  info.lua_files = #lua_files

  for _, filepath in ipairs(lua_files) do
    info.total_files = info.total_files + 1

    -- Get file size (if available through stat)
    local stat = vim.loop and vim.loop.fs_stat(filepath)
    if stat then
      info.file_sizes[filepath] = stat.size
    end

    -- Get modification time
    local mtime = files.get_mtime(filepath)
    if mtime then
      info.modification_times[filepath] = mtime
    end

    -- Track subdirectories
    local dir = vim.fn.fnamemodify(filepath, ':h')
    local relative_dir = files.get_relative_path(dir, directory)
    if relative_dir ~= '' and not info.subdirectories[relative_dir] then
      info.subdirectories[relative_dir] = 0
    end
    if relative_dir ~= '' then
      info.subdirectories[relative_dir] = info.subdirectories[relative_dir] + 1
    end
  end

  return info
end

return M
