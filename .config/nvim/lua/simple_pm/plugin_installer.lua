---@class PluginInstaller
local M = {}

local plugin_types = require 'simple_pm.plugin_types'
local toml_parser = require 'simple_pm.toml_parser'

---Installs a single plugin using vim.plug.add
---@param plugin PluginSpec The plugin to install
local function install_plugin(plugin)
  -- Extract repo name for vim.plug.add
  local repo_name = plugin_types.extract_repo_name(plugin.src)

  -- Build the plugin spec for vim.plug.add
  local plug_spec = {
    url = plugin.src,
  }

  -- Add version if specified
  if plugin.version then
    plug_spec.tag = plugin.version
  end

  -- Add the plugin
  vim.plug.add(repo_name, plug_spec)
end

---Installs all plugins from a flattened plugin list
---@param plugins PluginSpec[] List of plugins to install
local function install_plugins(plugins)
  for _, plugin in ipairs(plugins) do
    local success, err = pcall(install_plugin, plugin)
    if not success then
      vim.notify(
        string.format('Failed to install plugin %s: %s', plugin.name or plugin.src, err),
        vim.log.levels.ERROR
      )
    else
      vim.notify(
        string.format(
          'Installed plugin: %s',
          plugin.name or plugin_types.extract_repo_name(plugin.src)
        ),
        vim.log.levels.INFO
      )
    end
  end
end

---Sources a Lua file if it exists
---@param filepath string Path to the Lua file
local function source_lua_file(filepath)
  if vim.fn.filereadable(filepath) == 1 then
    local success, err = pcall(dofile, filepath)
    if not success then
      vim.notify(string.format('Error sourcing %s: %s', filepath, err), vim.log.levels.ERROR)
    else
      vim.notify(string.format('Sourced: %s', filepath), vim.log.levels.DEBUG)
    end
  end
end

---Sources all Lua files in a directory (non-recursive, depth 1)
---@param dirpath string Path to the directory
local function source_directory(dirpath)
  if vim.fn.isdirectory(dirpath) == 0 then
    return
  end

  local files = vim.fn.glob(dirpath .. '/*.lua', false, true)
  for _, filepath in ipairs(files) do
    source_lua_file(filepath)
  end
end

---Sets up the global keymap store for immediate keymap setting
local function setup_keymap_system()
  local keymap = require 'simple_pm.keymap'
  local compat = require 'simple_pm.compat'

  -- Set up both the new system and compatibility layer
  keymap.create_global_store()
  compat.setup_global_compat()

  vim.notify('Simplified keymap system and compatibility layer initialized', vim.log.levels.DEBUG)
end

---Sources configuration files in the specified order
---@param config_root string Root directory of the neovim config
local function source_config_files(config_root)
  -- Set up the simplified keymap system first
  setup_keymap_system()

  -- Source plugins configuration (but NOT init.lua as it's already being executed)
  local plugins_lua = config_root .. '/plugins.lua'
  source_lua_file(plugins_lua)

  local plugins_dir = config_root .. '/plugins'
  source_directory(plugins_dir)

  -- Source keybindings
  local keybindings_lua = config_root .. '/keybindings.lua'
  source_lua_file(keybindings_lua)

  local keybindings_dir = config_root .. '/keybindings'
  source_directory(keybindings_dir)
end

---Main function to install plugins and source configuration
---@param plugins_toml_path string? Path to plugins.toml (defaults to config_root/plugins.toml)
function M.install_and_configure(plugins_toml_path)
  local config_root = vim.fn.stdpath 'config'
  plugins_toml_path = plugins_toml_path or (config_root .. '/plugins.toml')

  -- Check if plugins.toml exists
  if vim.fn.filereadable(plugins_toml_path) == 0 then
    vim.notify(
      string.format('plugins.toml not found at: %s', plugins_toml_path),
      vim.log.levels.ERROR
    )
    return
  end

  -- Parse plugins.toml
  local success, config = pcall(toml_parser.parse_plugins_toml, plugins_toml_path)
  if not success then
    vim.notify(string.format('Failed to parse plugins.toml: %s', config), vim.log.levels.ERROR)
    return
  end

  -- Validate the configuration
  local valid, err = plugin_types.validate_config(config)
  if not valid then
    vim.notify(string.format('Invalid plugin configuration: %s', err), vim.log.levels.ERROR)
    return
  end

  -- Flatten plugins (include dependencies as separate entries)
  local flattened_plugins = plugin_types.flatten_plugins(config)

  vim.notify(string.format('Installing %d plugins...', #flattened_plugins), vim.log.levels.INFO)

  -- Install all plugins
  install_plugins(flattened_plugins)

  -- Source configuration files after plugin installation
  vim.notify('Sourcing configuration files...', vim.log.levels.INFO)
  source_config_files(config_root)

  vim.notify('Plugin installation and configuration complete!', vim.log.levels.INFO)
end

---Debug function to show parsed plugins without installing
---@param plugins_toml_path string? Path to plugins.toml
function M.debug_plugins(plugins_toml_path)
  local config_root = vim.fn.stdpath 'config'
  plugins_toml_path = plugins_toml_path or (config_root .. '/plugins.toml')

  local success, config = pcall(toml_parser.parse_plugins_toml, plugins_toml_path)
  if not success then
    print('Failed to parse plugins.toml:', config)
    return
  end

  local valid, err = plugin_types.validate_config(config)
  if not valid then
    print('Invalid configuration:', err)
    return
  end

  local flattened_plugins = plugin_types.flatten_plugins(config)

  print(string.format('Found %d plugins:', #flattened_plugins))
  for i, plugin in ipairs(flattened_plugins) do
    print(string.format('  %d. %s -> %s', i, plugin.name or 'unnamed', plugin.src))
    if plugin.version then
      print(string.format('     Version: %s', plugin.version))
    end
  end
end

---Test the simplified keymap system
function M.test_keymaps()
  local keymap = require 'simple_pm.keymap'

  -- Test setting some example keymaps
  local test_keymaps = {
    { map = '<leader>tt', cmd = ':echo "Test keymap works!"<CR>', desc = 'Test keymap' },
    {
      map = '<leader>tf',
      cmd = function()
        print 'Function keymap works!'
      end,
      desc = 'Test function keymap',
    },
  }

  local success_count, total_count = keymap.set_immediate(test_keymaps)
  print(string.format('Test keymaps: %d/%d successful', success_count, total_count))
end

return M
