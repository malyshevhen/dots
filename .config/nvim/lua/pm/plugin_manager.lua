local M = {}

local log = require 'pm.utils.vim_logger'
local loader = require 'pm.utils.loader'

-- Defaults
---@type string Path to the plugins, directory by default
local _plugins_dir = vim.fn.stdpath 'config' .. '/lua/plugins'
---@type string Path to the keymaps, directory by default, but can be a file
local _keymaps_dir = vim.fn.stdpath 'config' .. '/lua/keymaps.lua'

-- Private helper function

---Loads all plugins from the plugins directory using the new loader utility.
---
---@param plugins_dir string Path to the plugins directory
---@param options table|nil Optional configuration
---@return table Results of plugin loading
local function _load_plugins(plugins_dir, options)
  return loader.load_plugins_with_require(plugins_dir, options)
end

---Loads all keymaps using the new loader utility.
---
---@param keymaps_path string Path to the keymaps file
---@return boolean success Whether the keymaps were loaded successfully
local function _load_keymaps(keymaps_path)
  return loader.load_keymaps_file(keymaps_path)
end

---@alias KeymapMode
---| "n" # normal
---| "i" # insert
---| "v" # visual
---| "x" # visual block
---| "t" # terminal
---| "o" # operator-pending
---| "s" # select

---@class Keymap
---@field map string The key combination to map
---@field cmd string|function The command to execute
---@field desc string|nil Optional description for the keymap
---@field mode KeymapMode|KeymapMode[]|nil Mode(s) for the keymap (defaults to "n")
local Keymap = {}
Keymap.__index = Keymap

---@alias Keymaps Keymap[]

-- Private helper functions
---@param keymap Keymap
---@return boolean is_valid Whether the keymap is valid
local function is_valid_keymap(keymap)
  return keymap
    and type(keymap) == 'table'
    and keymap.map
    and type(keymap.map) == 'string'
    and keymap.cmd
    and keymap.map ~= ''
end

---@param value string|function
---@return string|function safe_value Safe version of the value
local function safe_tostring(value)
  if type(value) == 'function' then
    return '<function>'
  elseif type(value) == 'string' then
    return value
  else
    return tostring(value)
  end
end

---Sets up a single keymap safely.
---
---@return boolean success Whether the keymap was set successfully
function Keymap:set()
  if not is_valid_keymap(self) then
    vim.notify(string.format('Invalid keymap: %s', vim.inspect(self)), vim.log.levels.WARN)
    return false
  end

  local modes = self.mode or 'n'
  -- Ensure modes is always a table for consistent processing
  if type(modes) ~= 'table' then
    modes = { modes }
  end

  local opts = {
    desc = self.desc,
    noremap = true,
    silent = true,
  }

  -- Set keymap for each mode
  for _, mode in ipairs(modes) do
    local ok, err = pcall(vim.keymap.set, mode, self.map, self.cmd, opts)
    if not ok then
      vim.notify(
        string.format("Failed to set keymap '%s' for mode '%s': %s", self.map, mode, err),
        vim.log.levels.ERROR
      )
      return false
    end
  end
  return true
end

---Returns a string representation of the keymap.
---
---@return string description String representation of the keymap
function Keymap:toString()
  local desc = self.desc or 'no description'
  local map = self.map or 'no map'
  local cmd = safe_tostring(self.cmd)
  local mode = self.mode or 'n'

  if type(mode) == 'table' then
    mode = table.concat(mode, ',')
  end

  return string.format('[%s] <%s>: %s -> %s', mode, desc, map, cmd)
end

---Creates a new Keymap instance.
---
---@param map string The key combination
---@param cmd string|function The command to execute
---@param desc string|nil Optional description
---@param mode KeymapMode|KeymapMode[]|nil Optional mode(s)
---@return Keymap keymap New Keymap instance
function Keymap.new(map, cmd, desc, mode)
  return setmetatable({
    map = map,
    cmd = cmd,
    desc = desc,
    mode = mode,
  }, Keymap)
end

---Formats a list of keymaps for display.
---
---@param mappings Keymaps List of keymaps
---@return string Formatted string
function Keymap.formatList(mappings)
  if not mappings or #mappings == 0 then
    return 'No keymaps'
  end

  local formatted = {}
  for _, mapping in ipairs(mappings) do
    if mapping then
      if type(mapping.toString) == 'function' then
        table.insert(formatted, mapping:toString())
      elseif is_valid_keymap(mapping) then
        local desc = mapping.desc or 'no description'
        local map = mapping.map or 'no map'
        local cmd = safe_tostring(mapping.cmd)
        local mode = mapping.mode or 'n'

        if type(mode) == 'table' then
          mode = table.concat(mode, ',')
        end

        table.insert(formatted, string.format('[%s] <%s>: %s -> %s', mode, desc, map, cmd))
      end
    end
  end

  return table.concat(formatted, '\n')
end

---Checks for conflicting keymaps and reports them.
---
---@param mappings Keymaps List of keymaps to check
---@return table<string, Keymap[]> conflicts Map of conflicting key combinations
function Keymap.check_conflicts(mappings)
  if not mappings then
    return {}
  end

  ---@type table<string, Keymap[]>
  local key_map = {}
  ---@type table<string, Keymap[]>
  local conflicts = {}

  for _, mapping in ipairs(mappings) do
    if is_valid_keymap(mapping) then
      local modes = type(mapping.mode) == 'table' and mapping.mode or { mapping.mode or 'n' }

      for i = 1, #modes do
        local mode = modes[i]
        local key = string.format('%s:%s', mode, mapping.map)

        if not key_map[key] then
          key_map[key] = {}
        end

        table.insert(key_map[key], mapping)

        -- If we have more than one mapping for the same key+mode combination
        if #key_map[key] > 1 then
          conflicts[key] = key_map[key]
        end
      end
    end
  end

  -- Report conflicts
  for key, conflicted_mappings in pairs(conflicts) do
    ---@type table<KeymapMode>, string
    local mode, map = key:match '([^:]+):(.+)'
    ---@type string
    local formatted_conflicts = Keymap.formatList(conflicted_mappings)

    vim.notify(
      string.format(
        "Keymap conflict detected for '%s' in mode '%s':\n%s",
        map,
        mode,
        formatted_conflicts
      ),
      vim.log.levels.WARN
    )
  end

  return conflicts
end

---Sets up multiple keymaps safely.
---
---@param mappings Keymaps List of keymaps to set
---@return table<string, boolean> results Map of keymap identifiers to success status
function Keymap.set_keymaps(mappings)
  if not mappings then
    return {}
  end

  local results = {}
  local success_count = 0
  local total_count = 0

  for i, keymap in ipairs(mappings) do
    if keymap then
      total_count = total_count + 1
      local identifier = string.format('%d:%s', i, keymap.map or 'unknown')

      local success
      if type(keymap.set) == 'function' then
        success = keymap:set()
      elseif is_valid_keymap(keymap) then
        success = Keymap.new(keymap.map, keymap.cmd, keymap.desc, keymap.mode):set()
      else
        vim.notify(
          string.format('Invalid keymap at index %d: %s', i, vim.inspect(keymap)),
          vim.log.levels.WARN
        )
        success = false
      end

      results[identifier] = success
      if success then
        success_count = success_count + 1
      end
    end
  end

  if total_count > 0 then
    vim.notify(
      string.format('Keymaps setup: %d/%d successful', success_count, total_count),
      success_count == total_count and vim.log.levels.INFO or vim.log.levels.WARN
    )
  end

  return results
end

---@class KeymapsStore
---@field keymaps Keymaps
---@field _keymaps_dir string
local KeymapsStore = {}
KeymapsStore.__index = KeymapsStore

---Creates a new keymaps store instance.
---
---@param keymaps_dir string? Path to the keymaps directory or file
---@return KeymapsStore store New keymaps store instance
function KeymapsStore.new(keymaps_dir)
  return setmetatable({
    keymaps = {},
    _keymaps_dir = keymaps_dir or _keymaps_dir,
  }, KeymapsStore)
end

---Adds a keymap to the keymaps store.
---
---@param keymap Keymap|Keymap[]
function KeymapsStore:map(keymap)
  if type(keymap) == 'table' then
    for _, keymap_ in ipairs(keymap) do
      if is_valid_keymap(keymap_) then
        table.insert(self.keymaps, keymap_)
      else
        log.warn_fmt('Invalid keymap: %s', vim.inspect(keymap_))
      end
    end
  elseif is_valid_keymap(keymap) then
    table.insert(self.keymaps, keymap)
  else
    log.warn_fmt('Invalid keymap: %s', vim.inspect(keymap))
  end
end

---Loads all keymaps from the keymaps directory.
function KeymapsStore:load()
  _load_keymaps(self._keymaps_dir)
end

---@class PluginOptions
---@field version string|nil Plugin version constraint
---@field opts table|nil Plugin configuration options
---@field config function|nil Plugin configuration function
---@field keymaps Keymaps|nil Plugin-specific keymaps
---@field deps string[]|nil Plugin dependencies

---@class Plug
---@field url string Plugin repository URL
---@field name string Plugin name/identifier
---@field opts PluginOptions|nil Plugin options
local Plug = {}
Plug.__index = Plug

---@alias Plugs Plug[]

-- Private helper for plugin validation
local function is_valid_plugin(plugin)
  return plugin
    and type(plugin) == 'table'
    and plugin.url
    and type(plugin.url) == 'string'
    and plugin.url ~= ''
    and plugin.name
    and type(plugin.name) == 'string'
    and plugin.name ~= ''
end

---Creates a new plugin instance.
---
---@param url string Plugin repository URL
---@param name string Plugin name/identifier
---@param opts PluginOptions|nil Plugin options
---@return Plug|nil plugin New plugin instance or nil if invalid
function Plug.new(url, name, opts)
  -- Validate required parameters
  if not url or type(url) ~= 'string' or url == '' then
    vim.notify('Plugin URL is required and must be a non-empty string', vim.log.levels.ERROR)
    return nil
  end

  if not name or type(name) ~= 'string' or name == '' then
    vim.notify('Plugin name is required and must be a non-empty string', vim.log.levels.ERROR)
    return nil
  end

  -- Validate opts if provided
  if opts and type(opts) ~= 'table' then
    vim.notify('Plugin options must be a table', vim.log.levels.ERROR)
    return nil
  end

  return setmetatable({
    url = url,
    name = name,
    opts = opts or {},
  }, Plug)
end

---Sets up the plugin safely.
---
---@return boolean success Whether setup was successful
function Plug:setup()
  if not is_valid_plugin(self) then
    vim.notify(
      string.format('Invalid plugin configuration: %s', vim.inspect(self)),
      vim.log.levels.ERROR
    )
    return false
  end

  local success = true

  -- Setup plugin with options
  if self.opts and self.opts.opts then
    local ok, plugin = pcall(require, self.name)
    if ok and type(plugin.setup) == 'function' then
      local setup_ok, err = pcall(plugin.setup, self.opts.opts)
      if not setup_ok then
        vim.notify(
          string.format("Failed to setup plugin '%s': %s", self.name, err),
          vim.log.levels.ERROR
        )
        success = false
      end
    elseif not ok then
      vim.notify(string.format("Plugin '%s' could not be loaded", self.name), vim.log.levels.WARN)
    end
  end

  -- Run custom configuration
  if self.opts and self.opts.config then
    if type(self.opts.config) == 'function' then
      local config_ok, err = pcall(self.opts.config)
      if not config_ok then
        vim.notify(
          string.format("Failed to run config for plugin '%s': %s", self.name, err),
          vim.log.levels.ERROR
        )
        success = false
      end
    else
      vim.notify(
        string.format("Plugin '%s' config must be a function", self.name),
        vim.log.levels.WARN
      )
    end
  end

  -- Setup plugin keymaps
  if self.opts and self.opts.keymaps then
    local keymap_results = Keymap.set_keymaps(self.opts.keymaps)
    -- Check if any keymaps failed
    for _, keymap_success in pairs(keymap_results) do
      if not keymap_success then
        success = false
        break
      end
    end
  end

  return success
end

---Installs all plugins using vim.pack.add.
---
---@param plugins Plugs List of plugins to install
---@return boolean success Whether installation was successful
function Plug.installAll(plugins)
  if not plugins or type(plugins) ~= 'table' then
    vim.notify('Plugins must be provided as a table', vim.log.levels.ERROR)
    return false
  end

  if #plugins == 0 then
    vim.notify('No plugins to install', vim.log.levels.INFO)
    return true
  end

  ---@type table<vim.pack.Spec>[]
  local specs = {}
  ---@type table<string, boolean>
  local processed_urls = {}

  for i, plugin in ipairs(plugins) do
    if not is_valid_plugin(plugin) then
      vim.notify(
        string.format('Invalid plugin at index %d: %s', i, vim.inspect(plugin)),
        vim.log.levels.ERROR
      )
      return false
    end

    -- Avoid duplicate plugin installations
    if not processed_urls[plugin.url] then
      processed_urls[plugin.url] = true

      ---@type vim.pack.Spec
      local spec = { src = plugin.url }
      if plugin.opts and plugin.opts.version then
        spec.version = plugin.opts.version
      end

      table.insert(specs, spec)

      -- Add dependencies
      if plugin.opts and plugin.opts.deps then
        if type(plugin.opts.deps) == 'table' then
          for _, dep_url in ipairs(plugin.opts.deps) do
            if type(dep_url) == 'string' and dep_url ~= '' and not processed_urls[dep_url] then
              processed_urls[dep_url] = true
              table.insert(specs, { src = dep_url })
            end
          end
        else
          vim.notify(
            string.format("Dependencies for plugin '%s' must be a table of strings", plugin.name),
            vim.log.levels.WARN
          )
        end
      end
    end
  end

  if #specs == 0 then
    vim.notify('No valid plugin specifications to install', vim.log.levels.WARN)
    return false
  end

  local ok, err = pcall(vim.pack.add, specs)
  if not ok then
    vim.notify(string.format('Failed to install plugins: %s', err), vim.log.levels.ERROR)
    return false
  end

  vim.notify(
    string.format('Successfully processed %d plugin(s) with %d specification(s)', #plugins, #specs),
    vim.log.levels.INFO
  )

  return true
end

---Returns a string representation of the plugin.
---
---@return string description String representation of the plugin
function Plug:toString()
  local deps_count = (self.opts and self.opts.deps) and #self.opts.deps or 0
  local keymaps_count = (self.opts and self.opts.keymaps) and #self.opts.keymaps or 0

  return string.format(
    'Plugin: %s (%s) - %d deps, %d keymaps',
    self.name,
    self.url,
    deps_count,
    keymaps_count
  )
end

---@class PluginManagerConfig
---@field plugins_dir string
---@field keymaps_dir string

---@class PluginManager
---@field plugins Plugs
---@field keymaps_store KeymapsStore
---@field _plugins_dir string
local PluginManager = {}
PluginManager.__index = PluginManager

---Creates a new plugin manager instance.
---
---@param opts? PluginManagerConfig
---@return PluginManager manager New plugin manager instance
function PluginManager.new(opts)
  local _opts = opts or {}

  -- Set default config values
  ---@type PluginManagerConfig
  local config = {
    plugins_dir = _opts.plugins_dir or _plugins_dir,
    keymaps_dir = _opts.keymaps_dir or _keymaps_dir,
  }

  return setmetatable({
    plugins = {},
    keymaps_store = KeymapsStore.new(config.keymaps_dir),
    _plugins_dir = config.plugins_dir,
  }, PluginManager)
end

---Initializes the plugin manager.
---
---Sets the global variable `PluginManager` to the new plugin manager instance.
---
---@return PluginManager manager New plugin manager instance
function PluginManager.init()
  _G.P = PluginManager.new()
  _G.K = KeymapsStore.new()

  return _G.P
end

---Adds a plugin to the plugin manager.
---
---@Param url string Plugin repository URL
---@Param name string Plugin name/identifier
---@Param opts PluginOptions Plugin options
function PluginManager:add(url, name, opts)
  local plugin = Plug.new(url, name, opts)

  if is_valid_plugin(plugin) then
    table.insert(self.plugins, plugin)
    return true
  else
    log.warn 'Invalid plugin configuration'
    return false
  end
end

---Sets up all plugins and keymaps using the new loader utilities.
function PluginManager:setup()
  -- Use the new loader to initialize keymaps first, then plugins
  local config = {
    keymaps_path = self.keymaps_store._keymaps_dir,
    plugins_dir = self._plugins_dir,
    options = { silent = false },
  }

  local init_results = loader.initialize(config)

  -- Handle keymaps initialization results
  if not init_results.keymaps.success then
    log.warn 'Keymaps initialization failed, but continuing with plugin setup'
  end

  -- Handle plugins initialization results
  local plugin_results = init_results.plugins
  if plugin_results.failure_count > 0 then
    for _, failed in ipairs(plugin_results.failed) do
      log.error_fmt('Failed to load plugin file: %s - %s', failed.module, failed.error)
    end
  end

  -- Install all plugins
  local install_success = Plug.installAll(self.plugins)
  if not install_success then
    log.error 'Plugin installation failed'
    return
  end

  -- Setup all plugins and collect keymaps
  ---@type Keymaps
  local all_keymaps = vim.deepcopy(_G.K and _G.K.keymaps or {})

  ---@type {name: string, error: string}[]
  local setup_failures = {}

  for _, plugin in ipairs(self.plugins) do
    local ok, result = pcall(function()
      return plugin:setup()
    end)
    if not ok then
      table.insert(setup_failures, {
        name = plugin.name or 'Unknown',
        error = result,
      })
      log.error_fmt('Failed to setup plugin: %s\n%s', plugin.name or 'Unknown', tostring(result))
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
    log.warn_fmt(
      'Plugin setup completed with %d failure(s): %s',
      #setup_failures,
      table.concat(failure_names, ', ')
    )
  else
    log.info_fmt('All %d plugins setup successfully', #self.plugins)
  end

  -- Check for keymap conflicts and setup all keymaps
  Keymap.check_conflicts(all_keymaps)
  Keymap.set_keymaps(all_keymaps)

  -- Log final summary
  log.info_fmt(
    'Plugin Manager setup completed - Keymaps: %s, Plugins loaded: %d/%d, Plugin setups: %d/%d',
    init_results.keymaps.success and 'Success' or 'Failed',
    plugin_results.success_count,
    plugin_results.total,
    #self.plugins - #setup_failures,
    #self.plugins
  )
end

function M.plugin_manager(opts)
  return PluginManager.new(opts)
end

return M
