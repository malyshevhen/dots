---@diagnostic disable: undefined-global
-- Type definitions and utilities for Neovim configuration
-- Provides structured plugin management and keymap handling

-- Ensure vim global is available
vim = vim
Snacks = Snacks

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
  return keymap and type(keymap) == 'table' and keymap.map and type(keymap.map) == 'string' and keymap.cmd and keymap.map ~= ''
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
      vim.notify(string.format("Failed to set keymap '%s' for mode '%s': %s", self.map, mode, err), vim.log.levels.ERROR)
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

    vim.notify(string.format("Keymap conflict detected for '%s' in mode '%s':\n%s", map, mode, formatted_conflicts), vim.log.levels.WARN)
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
        vim.notify(string.format('Invalid keymap at index %d: %s', i, vim.inspect(keymap)), vim.log.levels.WARN)
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
    vim.notify(string.format('Invalid plugin configuration: %s', vim.inspect(self)), vim.log.levels.ERROR)
    return false
  end

  local success = true

  -- Setup plugin with options
  if self.opts and self.opts.opts then
    local ok, plugin = pcall(require, self.name)
    if ok and type(plugin.setup) == 'function' then
      local setup_ok, err = pcall(plugin.setup, self.opts.opts)
      if not setup_ok then
        vim.notify(string.format("Failed to setup plugin '%s': %s", self.name, err), vim.log.levels.ERROR)
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
        vim.notify(string.format("Failed to run config for plugin '%s': %s", self.name, err), vim.log.levels.ERROR)
        success = false
      end
    else
      vim.notify(string.format("Plugin '%s' config must be a function", self.name), vim.log.levels.WARN)
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
      vim.notify(string.format('Invalid plugin at index %d: %s', i, vim.inspect(plugin)), vim.log.levels.ERROR)
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
          vim.notify(string.format("Dependencies for plugin '%s' must be a table of strings", plugin.name), vim.log.levels.WARN)
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

  vim.notify(string.format('Successfully processed %d plugin(s) with %d specification(s)', #plugins, #specs), vim.log.levels.INFO)

  return true
end

---Returns a string representation of the plugin.
---
---@return string description String representation of the plugin
function Plug:toString()
  local deps_count = (self.opts and self.opts.deps) and #self.opts.deps or 0
  local keymaps_count = (self.opts and self.opts.keymaps) and #self.opts.keymaps or 0

  return string.format('Plugin: %s (%s) - %d deps, %d keymaps', self.name, self.url, deps_count, keymaps_count)
end

-- Export public API
return {
  Keymap = Keymap,
  Plug = Plug,
}
