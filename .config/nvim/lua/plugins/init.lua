-- Plugins directory init file
-- This file is optional and provides a centralized way to access plugin utilities

-- Re-export the main plugins loader for convenience
local plugins_loader = require 'plugins'

-- Plugin management utilities
local M = {}

-- Re-export all utilities from the main plugins loader
M.get_plugins = plugins_loader.get_plugins
M.get_plugin = plugins_loader.get_plugin
M.reload = plugins_loader.reload
M.stats = plugins_loader.stats

-- Additional utilities specific to the plugins directory

---Get list of all available plugin files in the plugins directory
---@return string[] filenames List of plugin filenames (without .lua extension)
function M.list_available()
  local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
  local plugin_files = vim.fn.glob(plugins_dir .. '/*.lua', false, true)
  local filenames = {}

  for _, file_path in ipairs(plugin_files) do
    local filename = vim.fn.fnamemodify(file_path, ':t:r')
    -- Skip init.lua and README files
    if filename ~= 'init' and filename ~= 'README' then
      table.insert(filenames, filename)
    end
  end

  table.sort(filenames)
  return filenames
end

---Check if a specific plugin file exists
---@param plugin_name string Name of the plugin file (without .lua)
---@return boolean exists Whether the plugin file exists
function M.exists(plugin_name)
  local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
  local plugin_file = plugins_dir .. '/' .. plugin_name .. '.lua'
  return vim.fn.filereadable(plugin_file) == 1
end

---Get plugin file path
---@param plugin_name string Name of the plugin file (without .lua)
---@return string|nil path Full path to plugin file or nil if not found
function M.get_file_path(plugin_name)
  if M.exists(plugin_name) then
    return vim.fn.stdpath 'config' .. '/lua/plugins/' .. plugin_name .. '.lua'
  end
  return nil
end

---Print information about all loaded plugins
function M.info()
  local stats = M.stats()
  local available = M.list_available()

  print 'Plugin System Information:'
  print '========================'
  print('Available plugin files: ' .. #available)
  print('Loaded plugins: ' .. stats.total_plugins)
  print('Setup failures: ' .. stats.setup_failures)
  print('Total keymaps: ' .. stats.total_keymaps)
  print('Plugins with keymaps: ' .. stats.plugins_with_keymaps)
  print('Plugins with config: ' .. stats.plugins_with_config)
  print('Plugins with dependencies: ' .. stats.plugins_with_dependencies)

  if #available > 0 then
    print '\nAvailable plugins:'
    for _, name in ipairs(available) do
      print('  • ' .. name)
    end
  end
end

return M
