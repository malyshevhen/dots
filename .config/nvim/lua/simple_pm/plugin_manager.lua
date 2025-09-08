---@class PluginManager
local M = {}

local logger = require 'simple_pm.logger'
local plugin_types = require 'simple_pm.plugin_types'

---@class PluginManagerDependencies
---@field toml_parser table TOML parser implementation
---@field pack_installer table vim.pack installer wrapper
---@field file_sourcer table File sourcing implementation

---@class PluginManager
---@field dependencies PluginManagerDependencies
---@field logger table Contextual logger
local PluginManager = {}
PluginManager.__index = PluginManager

---Creates a new plugin manager instance
---@param dependencies PluginManagerDependencies Required dependencies
---@return PluginManager
function M.new(dependencies)
  if not dependencies then
    error 'PluginManager requires dependencies'
  end

  local required_deps = { 'toml_parser', 'pack_installer', 'file_sourcer' }
  for _, dep in ipairs(required_deps) do
    if not dependencies[dep] then
      error(string.format('Missing required dependency: %s', dep))
    end
  end

  local instance = setmetatable({
    dependencies = dependencies,
    logger = logger.create_context 'PluginManager',
  }, PluginManager)

  return instance
end

---Parses the plugins configuration file
---@param plugins_toml_path string Path to the plugins.toml file
---@return PluginConfig? config The parsed configuration
---@return string? error Error message if parsing fails
function PluginManager:parse_config(plugins_toml_path)
  self.logger.info(string.format('Parsing configuration: %s', plugins_toml_path))

  local success, result = pcall(self.dependencies.toml_parser.parse_plugins_toml, plugins_toml_path)
  if not success then
    local error_msg = string.format('Failed to parse plugins.toml: %s', result)
    self.logger.error(error_msg)
    return nil, error_msg
  end

  -- Validate the parsed configuration
  local valid, validation_error = plugin_types.validate_config(result)
  if not valid then
    local error_msg = string.format('Invalid plugin configuration: %s', validation_error)
    self.logger.error(error_msg)
    return nil, error_msg
  end

  self.logger.info(string.format('Found %d plugins', #result.plugins))
  return result, nil
end

---Flattens plugins configuration including dependencies
---@param config PluginConfig The plugin configuration
---@return PluginSpec[] flattened_plugins All plugins as individual entries
function PluginManager:flatten_plugins(config)
  self.logger.info 'Flattening plugin dependencies'

  local flattened = plugin_types.flatten_plugins(config)

  self.logger.info(string.format('Flattened to %d total plugins', #flattened))
  return flattened
end

---Installs all plugins using the pack installer
---@param plugins PluginSpec[] List of plugins to install
---@return boolean success True if installation was successful
---@return string? error Error message if installation fails
function PluginManager:install_plugins(plugins)
  if #plugins == 0 then
    self.logger.warn 'No plugins to install'
    return true, nil
  end

  self.logger.info(string.format('Installing %d plugins', #plugins))

  local success, error_msg = self.dependencies.pack_installer.install(plugins)

  if success then
    self.logger.info(string.format('Successfully installed %d plugins', #plugins))
  else
    self.logger.error(error_msg or 'Plugin installation failed')
  end

  return success, error_msg
end

---Sources configuration files after plugin installation
---@param config_root string Root directory of the configuration
---@return boolean success True if sourcing was successful
---@return string? error Error message if sourcing fails
function PluginManager:source_configs(config_root)
  self.logger.info 'Sourcing configuration files'

  local success, error_msg = self.dependencies.file_sourcer.source_configs(config_root)

  if success then
    self.logger.info 'Configuration files sourced successfully'
  else
    self.logger.error(error_msg or 'Configuration sourcing failed')
  end

  return success, error_msg
end

---Main method to install plugins and configure the system
---@param plugins_toml_path string Path to the plugins.toml file
---@param config_root string Root directory of the configuration
---@return boolean success True if the entire process was successful
---@return string? error Error message if any step fails
function PluginManager:setup(plugins_toml_path, config_root)
  self.logger.info 'Starting plugin management setup'

  -- Step 1: Parse configuration
  local config, parse_error = self:parse_config(plugins_toml_path)
  if not config then
    self.logger.error('Setup failed during parsing: ' .. (parse_error or 'unknown error'))
    return false, parse_error
  end

  -- Step 2: Flatten plugins
  local flattened_plugins = self:flatten_plugins(config)

  -- Step 3: Install plugins
  local install_success, install_error = self:install_plugins(flattened_plugins)
  if not install_success then
    self.logger.error('Setup failed during installation: ' .. (install_error or 'unknown error'))
    return false, install_error
  end

  -- Step 4: Source configuration files
  local source_success, source_error = self:source_configs(config_root)
  if not source_success then
    self.logger.error('Setup failed during config sourcing: ' .. (source_error or 'unknown error'))
    return false, source_error
  end

  self.logger.info 'Plugin management setup completed successfully'
  return true, nil
end

---Debug method to show parsed plugins without installing
---@param plugins_toml_path string Path to the plugins.toml file
---@return PluginSpec[]? plugins List of parsed plugins
---@return string? error Error message if parsing fails
function PluginManager:debug_plugins(plugins_toml_path)
  local config, error_msg = self:parse_config(plugins_toml_path)
  if not config then
    return nil, error_msg
  end

  local flattened_plugins = self:flatten_plugins(config)

  -- Output debug information
  print(string.format('Found %d plugins:', #flattened_plugins))
  for i, plugin in ipairs(flattened_plugins) do
    print(string.format('  %d. %s -> %s', i, plugin.name or 'unnamed', plugin.src))
    if plugin.version then
      print(string.format('     Version: %s', plugin.version))
    end
  end

  return flattened_plugins, nil
end

return M
