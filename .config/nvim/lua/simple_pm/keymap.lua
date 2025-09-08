---@class SimpleKeymap
local M = {}

---@class KeymapSpec
---@field map string The keymap key combination
---@field cmd string|function The command to execute
---@field desc string? Description for the keymap
---@field mode string|string[]? Mode(s) for the keymap (default: 'n')
---@field ft string? Filetype restriction
---@field opts table? Additional options for vim.keymap.set

---Global keymap store instance
local K = nil

---Validates a keymap specification
---@param keymap KeymapSpec The keymap to validate
---@return boolean valid True if the keymap is valid
---@return string? error_msg Error message if validation fails
local function validate_keymap(keymap)
  if type(keymap) ~= 'table' then
    return false, 'Keymap must be a table'
  end

  if not keymap.map or type(keymap.map) ~= 'string' then
    return false, "Keymap must have a 'map' field of type string"
  end

  if not keymap.cmd or (type(keymap.cmd) ~= 'string' and type(keymap.cmd) ~= 'function') then
    return false, "Keymap must have a 'cmd' field of type string or function"
  end

  if keymap.desc and type(keymap.desc) ~= 'string' then
    return false, "Keymap 'desc' must be a string"
  end

  if keymap.mode then
    if type(keymap.mode) == 'string' then
      -- Single mode is ok
    elseif type(keymap.mode) == 'table' then
      -- Array of modes - validate each
      for _, mode in ipairs(keymap.mode) do
        if type(mode) ~= 'string' then
          return false, "All modes in 'mode' array must be strings"
        end
      end
    else
      return false, "Keymap 'mode' must be a string or array of strings"
    end
  end

  if keymap.ft and type(keymap.ft) ~= 'string' then
    return false, "Keymap 'ft' must be a string"
  end

  if keymap.opts and type(keymap.opts) ~= 'table' then
    return false, "Keymap 'opts' must be a table"
  end

  return true, nil
end

---Sets a single keymap immediately
---@param keymap KeymapSpec The keymap to set
---@return boolean success True if the keymap was set successfully
local function set_keymap(keymap)
  local valid, err = validate_keymap(keymap)
  if not valid then
    vim.notify(string.format('Invalid keymap: %s', err), vim.log.levels.WARN)
    return false
  end

  -- Default mode to normal if not specified
  local mode = keymap.mode or 'n'

  -- Build options table
  local opts = keymap.opts or {}
  if keymap.desc then
    opts.desc = keymap.desc
  end

  -- Handle filetype-specific keymaps
  if keymap.ft then
    -- Create an autocommand for filetype-specific keymaps
    vim.api.nvim_create_autocmd('FileType', {
      pattern = keymap.ft,
      callback = function(args)
        vim.keymap.set(
          mode,
          keymap.map,
          keymap.cmd,
          vim.tbl_extend('force', opts, { buffer = args.buf })
        )
      end,
      desc = string.format('Set keymap %s for filetype %s', keymap.map, keymap.ft),
    })
  else
    -- Set global keymap immediately
    vim.keymap.set(mode, keymap.map, keymap.cmd, opts)
  end

  return true
end

---@class SimpleKeymapStore
local KeymapStore = {}
KeymapStore.__index = KeymapStore

---Creates a new keymap store
---@return SimpleKeymapStore
function KeymapStore.new()
  return setmetatable({}, KeymapStore)
end

---Maps keymaps immediately without collecting them
---@param keymaps KeymapSpec|KeymapSpec[] Single keymap or array of keymaps
---@return number success_count Number of successfully set keymaps
---@return number total_count Total number of keymaps attempted
function KeymapStore:map(keymaps)
  local success_count = 0
  local total_count = 0

  -- Handle single keymap or array of keymaps
  if keymaps.map then
    -- Single keymap (has .map field)
    total_count = 1
    if set_keymap(keymaps) then
      success_count = 1
    end
  else
    -- Array of keymaps
    for _, keymap in ipairs(keymaps) do
      total_count = total_count + 1
      if set_keymap(keymap) then
        success_count = success_count + 1
      end
    end
  end

  return success_count, total_count
end

---Creates and returns the global keymap store instance
---@return SimpleKeymapStore
function M.create_global_store()
  if not K then
    K = KeymapStore.new()
    _G.K = K
  end
  return K
end

---Gets the global keymap store instance
---@return SimpleKeymapStore?
function M.get_global_store()
  return K or _G.K
end

---Convenience function to map keymaps using the global store
---@param keymaps KeymapSpec|KeymapSpec[] Single keymap or array of keymaps
---@return number success_count Number of successfully set keymaps
---@return number total_count Total number of keymaps attempted
function M.map(keymaps)
  local store = M.get_global_store() or M.create_global_store()
  return store:map(keymaps)
end

---Directly sets keymaps without using the store (for immediate use)
---@param keymaps KeymapSpec|KeymapSpec[] Single keymap or array of keymaps
---@return number success_count Number of successfully set keymaps
---@return number total_count Total number of keymaps attempted
function M.set_immediate(keymaps)
  local success_count = 0
  local total_count = 0

  -- Handle single keymap or array of keymaps
  if keymaps.map then
    -- Single keymap (has .map field)
    total_count = 1
    if set_keymap(keymaps) then
      success_count = 1
    end
  else
    -- Array of keymaps
    for _, keymap in ipairs(keymaps) do
      total_count = total_count + 1
      if set_keymap(keymap) then
        success_count = success_count + 1
      end
    end
  end

  return success_count, total_count
end

return M
