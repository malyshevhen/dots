-- Set global variables to simplify plugin files
_G.Plug = require('types').Plug
_G.Keymap = require('types').Keymap

local Plug = _G.Plug
local Keymap = _G.Keymap

-- Dynamically load all plugin files from the plugins directory
local function load_plugins()
  local plugins = {}
  local plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'

  -- Check if plugins directory exists
  if vim.fn.isdirectory(plugins_dir) == 0 then
    vim.notify('Plugins directory not found: ' .. plugins_dir, vim.log.levels.ERROR)
    return {}
  end

  -- Get all .lua files in the plugins directory
  local plugin_files = vim.fn.glob(plugins_dir .. '/*.lua', false, true)

  for _, file_path in ipairs(plugin_files) do
    -- Extract filename without extension
    local filename = vim.fn.fnamemodify(file_path, ':t:r')

    -- Skip the init file if it exists
    if filename ~= 'init' then
      local ok, plugin = pcall(require, 'plugins.' .. filename)
      if ok and plugin then
        if type(plugin) == 'table' and plugin.url and plugin.name then
          table.insert(plugins, plugin)
        else
          vim.notify(string.format('Invalid plugin configuration in %s.lua', filename), vim.log.levels.WARN)
        end
      else
        vim.notify(string.format('Failed to load plugin: %s.lua - %s', filename, tostring(plugin)), vim.log.levels.ERROR)
      end
    end
  end

  return plugins
end

-- Load all plugins
local plugins = load_plugins()

-- Global keymaps (not plugin-specific)
-- stylua: ignore
local global_keymaps = {
  -- System clipboard operations
  { map = '<leader>y',  cmd = '"+y',                     desc = 'Yank (Clipboard)',    mode = { 'v', 'x' } },
  { map = '<leader>Y',  cmd = '"+Y',                     desc = 'Yank (Clipboard)',    mode = { 'v', 'x' } },
  { map = '<leader>p',  cmd = '"+p',                     desc = 'Paste (Clipboard)',   mode = { 'v', 'x' } },
  { map = '<leader>P',  cmd = '"+P',                     desc = 'Paste (Clipboard)',   mode = { 'v', 'x' } },

  -- Window navigation
  { map = '<c-k>',      cmd = ':wincmd k<CR>',           desc = 'Move to top pane' },
  { map = '<c-j>',      cmd = ':wincmd j<CR>',           desc = 'Move to bottom pane' },
  { map = '<c-h>',      cmd = ':wincmd h<CR>',           desc = 'Move to left pane' },
  { map = '<c-l>',      cmd = ':wincmd l<CR>',           desc = 'Move to right pane' },
  { map = '<leader>o',  cmd = ':update<CR> :source<CR>', desc = 'Save and source file' },

  -- LSP operations
  { map = '<leader>cr', cmd = vim.lsp.buf.rename,        desc = 'Code Rename',         mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action,   desc = 'Code Action',         mode = { 'n', 'v' } },
}

-- Install all plugins
local install_success = Plug.installAll(plugins)
if not install_success then
  vim.notify('Plugin installation failed', vim.log.levels.ERROR)
  return
end

-- Setup all plugins and collect keymaps
local all_keymaps = vim.deepcopy(global_keymaps)
local setup_failures = {}

for _, plugin in ipairs(plugins) do
  local ok, result = pcall(function()
    return plugin:setup()
  end)

  if not ok then
    table.insert(setup_failures, {
      name = plugin.name or 'Unknown',
      error = result,
    })
    vim.notify(string.format('Failed to setup plugin: %s\n%s', plugin.name or 'Unknown', tostring(result)), vim.log.levels.ERROR)
  elseif not result then
    table.insert(setup_failures, {
      name = plugin.name or 'Unknown',
      error = 'Setup returned false',
    })
  end

  -- Collect plugin keymaps
  if plugin.opts and plugin.opts.keymaps then
    vim.list_extend(all_keymaps, plugin.opts.keymaps)
  end
end

-- Report setup results
if #setup_failures > 0 then
  local failure_names = {}
  for _, failure in ipairs(setup_failures) do
    table.insert(failure_names, failure.name)
  end
  vim.notify(string.format('Plugin setup completed with %d failure(s): %s', #setup_failures, table.concat(failure_names, ', ')), vim.log.levels.WARN)
else
  vim.notify(string.format('All %d plugins setup successfully', #plugins), vim.log.levels.INFO)
end

-- Check for keymap conflicts and setup all keymaps
Keymap.check_conflicts(all_keymaps)
Keymap.set_keymaps(all_keymaps)

-- Optional: Provide utility functions for plugin management
local M = {}

--- Get list of all loaded plugins
---@return table
function M.get_plugins()
  return vim.deepcopy(plugins)
end

--- Get plugin by name
---@param name string
---@return table|nil
function M.get_plugin(name)
  for _, plugin in ipairs(plugins) do
    if plugin.name == name then
      return plugin
    end
  end
  return nil
end

--- Reload all plugins (useful for development)
function M.reload()
  -- Clear plugin cache
  for filename, _ in pairs(package.loaded) do
    if filename:match '^plugins%.' then
      package.loaded[filename] = nil
    end
  end

  -- Reload the plugins.lua file
  package.loaded['plugins'] = nil
  require 'plugins'

  vim.notify('Plugins reloaded', vim.log.levels.INFO)
end

--- Get plugin statistics
---@return table
function M.stats()
  local stats = {
    total_plugins = #plugins,
    setup_failures = #setup_failures,
    total_keymaps = #all_keymaps,
    plugins_with_keymaps = 0,
    plugins_with_config = 0,
    plugins_with_dependencies = 0,
  }

  for _, plugin in ipairs(plugins) do
    if plugin.opts then
      if plugin.opts.keymaps and #plugin.opts.keymaps > 0 then
        stats.plugins_with_keymaps = stats.plugins_with_keymaps + 1
      end
      if plugin.opts.config then
        stats.plugins_with_config = stats.plugins_with_config + 1
      end
      if plugin.opts.deps and #plugin.opts.deps > 0 then
        stats.plugins_with_dependencies = stats.plugins_with_dependencies + 1
      end
    end
  end

  return stats
end

return M
