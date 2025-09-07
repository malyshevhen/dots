local M = {}

local files = require 'pm.utils.files'
local loader = require 'pm.utils.loader'
local log = require 'pm.utils.vim_logger'

--- Print detailed information about a directory's Lua files
--- @param directory string Directory to analyze
--- @param title string|nil Optional title for the output
function M.analyze_directory(directory, title)
  title = title or string.format('Analysis of %s', directory)

  print(string.rep('=', 60))
  print(title)
  print(string.rep('=', 60))

  local info = loader.analyze_directory(directory)

  print(string.format('Total Lua files: %d', info.lua_files))
  print(string.format('Total files processed: %d', info.total_files))

  if next(info.subdirectories) then
    print '\nSubdirectories:'
    for dir, count in pairs(info.subdirectories) do
      print(string.format('  %s: %d files', dir, count))
    end
  end

  print '\nFile details:'
  local lua_files = files.get_lua_files(directory, true)
  for i, filepath in ipairs(lua_files) do
    local relative = files.get_relative_path(filepath, vim.fn.stdpath 'config')
    local basename = files.get_basename(filepath)
    local mtime = files.get_mtime(filepath)
    local mtime_str = mtime and os.date('%Y-%m-%d %H:%M:%S', mtime) or 'unknown'

    print(string.format('  %d. %s (%s) - modified: %s', i, basename, relative, mtime_str))
  end

  print(string.rep('=', 60))
end

--- Debug plugin loading process
--- @param plugins_dir string Path to plugins directory
--- @return table Debug results
function M.debug_plugins(plugins_dir)
  print '\n[DEBUG] Starting plugin loading analysis...'

  local results = loader.load_plugins_with_require(plugins_dir, { silent = true })

  print(
    string.format(
      '[DEBUG] Plugin loading results: %d/%d successful',
      results.success_count,
      results.total
    )
  )

  if #results.successful > 0 then
    print '[DEBUG] Successfully loaded plugins:'
    for _, success in ipairs(results.successful) do
      local relative = files.get_relative_path(success.filepath, vim.fn.stdpath 'config')
      print(string.format('  ✓ %s (%s)', success.module, relative))
    end
  end

  if #results.failed > 0 then
    print '[DEBUG] Failed to load plugins:'
    for _, failure in ipairs(results.failed) do
      local relative = files.get_relative_path(failure.filepath, vim.fn.stdpath 'config')
      print(string.format('  ✗ %s (%s) - %s', failure.module, relative, failure.error))
    end
  end

  return results
end

--- Debug config module loading process
--- @param module_name string Name of the module
--- @param method_name string|nil Method to call (default: 'setup')
--- @return boolean Success status
function M.debug_config_module(module_name, method_name)
  method_name = method_name or 'setup'
  print(string.format('\n[DEBUG] Starting %s module analysis...', module_name))

  local ok, module = pcall(require, module_name)
  if not ok then
    print(string.format('[DEBUG] ✗ Module not found: %s', module_name))
    return false
  end

  if type(module[method_name]) ~= 'function' then
    print(
      string.format(
        '[DEBUG] ✗ Method %s.%s() not found or not a function',
        module_name,
        method_name
      )
    )
    return false
  end

  local success, err = pcall(module[method_name])
  if success then
    print(string.format('[DEBUG] ✓ %s.%s() called successfully', module_name, method_name))
  else
    print(string.format('[DEBUG] ✗ %s.%s() failed: %s', module_name, method_name, tostring(err)))
  end

  return success
end

--- Debug keymap loading process
--- @param keymaps_path string Path to keymaps file
--- @return boolean Success status
function M.debug_keymaps(keymaps_path)
  print '\n[DEBUG] Starting keymap loading analysis...'

  if not files.file_exists(keymaps_path) then
    print(string.format('[DEBUG] ✗ Keymaps file not found: %s', keymaps_path))
    return false
  end

  local relative = files.get_relative_path(keymaps_path, vim.fn.stdpath 'config')
  local mtime = files.get_mtime(keymaps_path)
  local mtime_str = mtime and os.date('%Y-%m-%d %H:%M:%S', mtime) or 'unknown'

  print(string.format('[DEBUG] Keymaps file: %s', relative))
  print(string.format('[DEBUG] Last modified: %s', mtime_str))

  -- Count current keymaps before loading
  local keymaps_before = _G.K and #_G.K.keymaps or 0

  local success = loader.load_keymaps_file(keymaps_path)

  -- Count keymaps after loading
  local keymaps_after = _G.K and #_G.K.keymaps or 0
  local new_keymaps = keymaps_after - keymaps_before

  if success then
    print(string.format('[DEBUG] ✓ Keymaps loaded successfully (%d new keymaps)', new_keymaps))
  else
    print '[DEBUG] ✗ Failed to load keymaps'
  end

  return success
end

--- Comprehensive debug of the entire initialization process
--- @param config table Configuration for initialization
function M.debug_initialization(config)
  print('\n' .. string.rep('=', 80))
  print 'PLUGIN MANAGER INITIALIZATION DEBUG'
  print(string.rep('=', 80))

  -- Analyze directories first
  M.analyze_directory(vim.fn.fnamemodify(config.keymaps_path, ':h'), 'Keymaps Directory')
  M.analyze_directory(config.plugins_dir, 'Plugins Directory')

  -- Debug config modules
  local options_success = false
  local auto_cmds_success = false
  local lsp_cfg_success = false

  if config.options_module then
    options_success = M.debug_config_module(config.options_module, 'setup')
  end

  -- Debug the loading process
  local keymap_success = M.debug_keymaps(config.keymaps_path)
  local plugin_results = M.debug_plugins(config.plugins_dir)

  if config.auto_cmds_module then
    auto_cmds_success = M.debug_config_module(config.auto_cmds_module, 'setup')
  end

  if config.lsp_cfg_module then
    lsp_cfg_success = M.debug_config_module(config.lsp_cfg_module, 'enable')
  end

  -- Summary
  print '\n[DEBUG] INITIALIZATION SUMMARY'
  print(string.rep('-', 40))
  if config.options_module then
    print(string.format('Options: %s', options_success and 'SUCCESS' or 'FAILED'))
  end
  print(string.format('Keymaps: %s', keymap_success and 'SUCCESS' or 'FAILED'))
  print(
    string.format('Plugins: %d/%d successful', plugin_results.success_count, plugin_results.total)
  )
  if config.auto_cmds_module then
    print(string.format('AutoCmds: %s', auto_cmds_success and 'SUCCESS' or 'FAILED'))
  end
  if config.lsp_cfg_module then
    print(string.format('LSP Config: %s', lsp_cfg_success and 'SUCCESS' or 'FAILED'))
  end

  -- Global state analysis
  if _G.P then
    print(string.format('Global plugin manager (P): %d plugins registered', #_G.P.plugins))
  else
    print 'Global plugin manager (P): NOT INITIALIZED'
  end

  if _G.K then
    print(string.format('Global keymap store (K): %d keymaps registered', #_G.K.keymaps))
  else
    print 'Global keymap store (K): NOT INITIALIZED'
  end

  -- Additional status checks
  print '\n[DEBUG] SYSTEM STATUS'
  print(string.rep('-', 40))
  print(
    string.format('Leader key: %s', vim.g.mapleader and '"' .. vim.g.mapleader .. '"' or 'not set')
  )
  print(string.format('LSP clients available: %d', #vim.lsp.get_clients()))

  -- Check for common autocmd groups
  local autocmd_groups = vim.api.nvim_get_autocmds {}
  local highlight_yank_found = false
  for _, group in pairs(autocmd_groups) do
    if group.group_name and group.group_name:match 'Highlight%-yank' then
      highlight_yank_found = true
      break
    end
  end
  print(
    string.format('Highlight-yank autocmd: %s', highlight_yank_found and 'FOUND' or 'NOT FOUND')
  )

  print(string.rep('=', 80))
end

--- Show current plugin manager state
function M.show_state()
  print '\n[DEBUG] CURRENT PLUGIN MANAGER STATE'
  print(string.rep('-', 50))

  if _G.P then
    print(string.format('Plugins registered: %d', #_G.P.plugins))
    for i, plugin in ipairs(_G.P.plugins) do
      local keymaps_count = (plugin.opts and plugin.opts.keymaps) and #plugin.opts.keymaps or 0
      print(string.format('  %d. %s (%s) - %d keymaps', i, plugin.name, plugin.url, keymaps_count))
    end
  else
    print 'Plugin manager (P) not initialized'
  end

  if _G.K then
    print(string.format('\nKeymaps registered: %d', #_G.K.keymaps))
    for i, keymap in ipairs(_G.K.keymaps) do
      local desc = keymap.desc or 'no description'
      local modes
      if type(keymap.mode) == 'table' then
        modes = table.concat(keymap.mode --[[@as table]], ',')
      else
        modes = tostring(keymap.mode or 'n')
      end
      print(string.format('  %d. [%s] %s - %s', i, modes, keymap.map, desc))
    end
  else
    print 'Keymap store (K) not initialized'
  end
end

--- Test file loading functions
--- @param directory string Directory to test
function M.test_file_loading(directory)
  print(string.format('\n[DEBUG] TESTING FILE LOADING: %s', directory))
  print(string.rep('-', 60))

  -- Test get_lua_files
  local lua_files = files.get_lua_files(directory, true)
  print(string.format('get_lua_files found: %d files', #lua_files))

  -- Test load_lua_files_safe
  local results = files.load_lua_files_safe(directory, { silent = true })
  print(
    string.format('load_lua_files_safe: %d/%d successful', results.success_count, results.total)
  )

  if results.failure_count > 0 then
    print 'Failures:'
    for _, failure in ipairs(results.failed) do
      local relative = files.get_relative_path(failure.filepath, vim.fn.stdpath 'config')
      print(string.format('  ✗ %s - %s', relative, failure.error))
    end
  end
end

--- Create debug commands for easy access
function M.setup_debug_commands()
  vim.api.nvim_create_user_command('PluginManagerDebug', function()
    local config = {
      keymaps_path = vim.fn.stdpath 'config' .. '/lua/keymaps.lua',
      plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins',
    }
    M.debug_initialization(config)
  end, { desc = 'Debug plugin manager initialization' })

  vim.api.nvim_create_user_command('PluginManagerState', function()
    M.show_state()
  end, { desc = 'Show current plugin manager state' })

  vim.api.nvim_create_user_command('PluginManagerAnalyze', function(opts)
    local dir = opts.args ~= '' and opts.args or vim.fn.stdpath 'config' .. '/lua/plugins'
    M.analyze_directory(dir)
  end, {
    nargs = '?',
    complete = 'dir',
    desc = 'Analyze directory for Lua files',
  })
end

return M
