---@class SimplePMCompat
---Compatibility layer for existing K:map interface
local M = {}

local keymap = require 'simple_pm.keymap'

---@class CompatKeymap
---@field map string The keymap key combination
---@field cmd string|function The command to execute
---@field desc string? Description for the keymap
---@field mode string|string[]? Mode(s) for the keymap (default: 'n')
---@field ft string? Filetype restriction
---@field opts table? Additional options for vim.keymap.set

---@class CompatKeymapStore
---Compatibility wrapper that mimics the old K:map interface
local CompatKeymapStore = {}
CompatKeymapStore.__index = CompatKeymapStore

---Creates a new compatibility keymap store
---@return CompatKeymapStore
function CompatKeymapStore.new()
  local store = setmetatable({}, CompatKeymapStore)
  return store
end

---Maps keymaps immediately (compatible with old K:map interface)
---@param keymaps CompatKeymap|CompatKeymap[] Single keymap or array of keymaps
---@return CompatKeymapStore self For method chaining
function CompatKeymapStore:map(keymaps)
  -- Convert old keymap format to new format if needed
  local converted_keymaps = {}

  -- Handle single keymap or array
  local keymap_list = keymaps
  if keymaps.map then
    -- Single keymap
    keymap_list = { keymaps }
  end

  for _, old_keymap in ipairs(keymap_list) do
    -- Convert old format to new format
    local new_keymap = {
      map = old_keymap.map,
      cmd = old_keymap.cmd,
      desc = old_keymap.desc,
      mode = old_keymap.mode,
      ft = old_keymap.ft,
      opts = old_keymap.opts,
    }

    table.insert(converted_keymaps, new_keymap)
  end

  -- Set keymaps immediately using the simplified system
  local success_count, total_count = keymap.set_immediate(converted_keymaps)

  if total_count > 0 then
    local level = success_count == total_count and vim.log.levels.DEBUG or vim.log.levels.WARN
    vim.notify(string.format('Keymaps: %d/%d successful', success_count, total_count), level)
  end

  return self
end

---Creates and sets up the global compatibility K instance
---@return CompatKeymapStore
function M.setup_global_compat()
  local compat_store = CompatKeymapStore.new()
  _G.K = compat_store
  return compat_store
end

---Gets the global compatibility K instance
---@return CompatKeymapStore?
function M.get_global_compat()
  return _G.K
end

---Ensures the global K compatibility layer is available
---@return CompatKeymapStore
function M.ensure_global_compat()
  if not _G.K or type(_G.K.map) ~= 'function' then
    return M.setup_global_compat()
  end
  return _G.K
end

return M
