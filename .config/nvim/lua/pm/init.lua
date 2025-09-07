local M = {}

local loader = require 'pm.utils.loader'
local debug = require 'pm.utils.debug'
local files = require 'pm.utils.files'

--- Initialize the plugin manager with default configuration
--- @param opts table|nil Optional configuration overrides
--- @return table Results of initialization
function M.init(opts)
  opts = opts or {}

  -- Default configuration
  local config = {
    options_module = opts.options_module or 'options',
    keymaps_path = opts.keymaps_path or vim.fn.stdpath 'config' .. '/lua/keymaps.lua',
    plugins_dir = opts.plugins_dir or vim.fn.stdpath 'config' .. '/lua/plugins',
    auto_cmds_module = opts.auto_cmds_module or 'auto_cmds',
    lsp_cfg_module = opts.lsp_cfg_module or 'lsp_cfg',
    options = opts.options or { silent = false },
  }

  -- Validate paths and modules
  if config.options_module then
    local ok, _ = pcall(require, config.options_module)
    if not ok then
      vim.notify(
        'Warning: Options module not found: ' .. config.options_module,
        vim.log.levels.WARN
      )
    end
  end

  if not files.file_exists(config.keymaps_path) then
    vim.notify('Warning: Keymaps file not found: ' .. config.keymaps_path, vim.log.levels.WARN)
  end

  if vim.fn.isdirectory(config.plugins_dir) ~= 1 then
    vim.notify('Warning: Plugins directory not found: ' .. config.plugins_dir, vim.log.levels.WARN)
  end

  if config.auto_cmds_module then
    local ok, _ = pcall(require, config.auto_cmds_module)
    if not ok then
      vim.notify(
        'Warning: Auto commands module not found: ' .. config.auto_cmds_module,
        vim.log.levels.WARN
      )
    end
  end

  if config.lsp_cfg_module then
    local ok, _ = pcall(require, config.lsp_cfg_module)
    if not ok then
      vim.notify(
        'Warning: LSP config module not found: ' .. config.lsp_cfg_module,
        vim.log.levels.WARN
      )
    end
  end

  -- Initialize using the loader
  local results = loader.initialize(config)

  -- Setup debug commands if requested
  if opts.setup_debug_commands then
    debug.setup_debug_commands()
  end

  return results
end

--- Quick setup function for common use cases
--- @param keymaps_first boolean|nil Whether to load keymaps first (default: true)
--- @param debug_mode boolean|nil Whether to enable debug commands (default: false)
--- @return table Results of initialization
function M.setup(keymaps_first, debug_mode)
  keymaps_first = keymaps_first == nil and true or keymaps_first
  debug_mode = debug_mode or false

  local results = M.init {
    setup_debug_commands = debug_mode,
    options = { silent = not debug_mode },
  }

  if debug_mode then
    vim.notify('Plugin Manager initialized with debug mode enabled', vim.log.levels.INFO)
    vim.notify(
      'Available commands: :PluginManagerDebug, :PluginManagerState, :PluginManagerAnalyze',
      vim.log.levels.INFO
    )
  end

  return results
end

--- Analyze and report on plugin manager configuration
--- @param opts table|nil Optional configuration
function M.analyze(opts)
  opts = opts or {}

  local config = {
    options_module = opts.options_module or 'options',
    keymaps_path = opts.keymaps_path or vim.fn.stdpath 'config' .. '/lua/keymaps.lua',
    plugins_dir = opts.plugins_dir or vim.fn.stdpath 'config' .. '/lua/plugins',
    auto_cmds_module = opts.auto_cmds_module or 'auto_cmds',
    lsp_cfg_module = opts.lsp_cfg_module or 'lsp_cfg',
  }

  debug.debug_initialization(config)
end

--- Get information about loaded plugins and keymaps
--- @return table Current state information
function M.get_state()
  local state = {
    plugins = {},
    keymaps = {},
    global_state = {
      plugin_manager_initialized = _G.P ~= nil,
      keymap_store_initialized = _G.K ~= nil,
    },
  }

  if _G.P then
    state.plugins = {
      count = #_G.P.plugins,
      list = _G.P.plugins,
    }
  end

  if _G.K then
    state.keymaps = {
      count = #_G.K.keymaps,
      list = _G.K.keymaps,
    }
  end

  return state
end

--- Reload keymaps from file
--- @param keymaps_path string|nil Optional path to keymaps file
--- @return boolean Success status
function M.reload_keymaps(keymaps_path)
  keymaps_path = keymaps_path or vim.fn.stdpath 'config' .. '/lua/keymaps.lua'

  -- Clear existing keymaps in the store
  if _G.K then
    _G.K.keymaps = {}
  end

  return loader.load_keymaps_file(keymaps_path)
end

--- Reload plugins from directory
--- @param plugins_dir string|nil Optional path to plugins directory
--- @return table Results of plugin reload
function M.reload_plugins(plugins_dir)
  plugins_dir = plugins_dir or vim.fn.stdpath 'config' .. '/lua/plugins'

  -- Note: This doesn't unload already loaded plugins, just loads new ones
  -- For full reload, Neovim restart is recommended
  return loader.load_plugins_with_require(plugins_dir, { silent = false })
end

--- Export utilities for direct access
M.loader = loader
M.debug = debug
M.files = files

return M
