---@class SimplePM
local M = {}

local plugin_installer = require 'simple_pm.plugin_installer'
local keymap = require 'simple_pm.keymap'
local compat = require 'simple_pm.compat'

---Default configuration for the simple plugin manager
---@class SimplePMConfig
---@field plugins_toml_path string? Path to plugins.toml (defaults to config_root/plugins.toml)
---@field auto_source_configs boolean? Whether to automatically source config files (default: true)
---@field auto_setup_keymaps boolean? Whether to automatically setup keymap system (default: true)
---@field debug_mode boolean? Enable debug logging (default: false)

---@type SimplePMConfig
local default_config = {
  plugins_toml_path = nil,
  auto_source_configs = true,
  auto_setup_keymaps = true,
  debug_mode = false,
}

---Merges user config with defaults
---@param user_config SimplePMConfig? User configuration
---@return SimplePMConfig merged_config
local function merge_config(user_config)
  return vim.tbl_deep_extend('force', default_config, user_config or {})
end

---Sets up logging level based on debug mode
---@param debug_mode boolean
local function setup_logging(debug_mode)
  if debug_mode then
    vim.notify('Simple Plugin Manager: Debug mode enabled', vim.log.levels.INFO)
  end
end

---Sets up the keymap system
---@param config SimplePMConfig
local function setup_keymaps(config)
  if config.auto_setup_keymaps then
    keymap.create_global_store()
    compat.setup_global_compat()
    if config.debug_mode then
      vim.notify(
        'Simple Plugin Manager: Keymap system and compatibility layer initialized',
        vim.log.levels.DEBUG
      )
    end
  end
end

---Main initialization function
---@param user_config SimplePMConfig? Configuration options
---@return boolean success True if initialization was successful
function M.init(user_config)
  local config = merge_config(user_config)

  setup_logging(config.debug_mode)

  -- Set up keymap system first (needed for config files that define keymaps)
  setup_keymaps(config)

  -- Install plugins and source configuration files
  local success = pcall(plugin_installer.install_and_configure, config.plugins_toml_path)

  if not success then
    vim.notify('Simple Plugin Manager: Failed to initialize', vim.log.levels.ERROR)
    return false
  end

  if config.debug_mode then
    vim.notify('Simple Plugin Manager: Initialization complete', vim.log.levels.INFO)
  end

  return true
end

---Quick setup function with minimal configuration
---@param plugins_toml_path string? Path to plugins.toml file
---@return boolean success True if setup was successful
function M.setup(plugins_toml_path)
  return M.init {
    plugins_toml_path = plugins_toml_path,
    debug_mode = false,
  }
end

---Setup with debug mode enabled
---@param plugins_toml_path string? Path to plugins.toml file
---@return boolean success True if setup was successful
function M.setup_debug(plugins_toml_path)
  return M.init {
    plugins_toml_path = plugins_toml_path,
    debug_mode = true,
  }
end

---Get the keymap system for direct use
---@return table keymap_module The keymap module
function M.keymap()
  return keymap
end

---Get the plugin installer for direct use
---@return table installer_module The plugin installer module
function M.installer()
  return plugin_installer
end

---Create user commands for debugging and management
local function create_user_commands()
  -- Debug command to show parsed plugins
  vim.api.nvim_create_user_command('SimplePMDebugPlugins', function()
    plugin_installer.debug_plugins()
  end, { desc = 'Show parsed plugins from plugins.toml' })

  -- Test keymap system
  vim.api.nvim_create_user_command('SimplePMTestKeymaps', function()
    plugin_installer.test_keymaps()
  end, { desc = 'Test the simplified keymap system' })

  -- Reinstall plugins
  vim.api.nvim_create_user_command('SimplePMReinstall', function()
    plugin_installer.install_and_configure()
  end, { desc = 'Reinstall plugins and source configuration' })
end

-- Set up user commands when the module is loaded
create_user_commands()

return M
