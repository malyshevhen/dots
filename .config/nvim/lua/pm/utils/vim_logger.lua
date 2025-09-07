---@class Logger
local M = {}

---@type boolean
M._enabled = true

function M.disable()
  M._enabled = false
end

---@param msg string
function M.debug(msg)
  if not M._enabled then
    return
  end

  vim.notify(msg, vim.log.levels.DEBUG)
end

---@param template string
---@param ... any # any number of arguments
function M.debug_fmt(template, ...)
  if not M._enabled then
    return
  end

  vim.notify(string.format(template, ...), vim.log.levels.DEBUG)
end

---@param msg string
function M.info(msg)
  if not M._enabled then
    return
  end

  vim.notify(msg, vim.log.levels.INFO)
end

---@param template string
---@param ... any # any number of arguments
function M.info_fmt(template, ...)
  if not M._enabled then
    return
  end

  vim.notify(string.format(template, ...), vim.log.levels.INFO)
end

---@param msg string
function M.warn(msg)
  if not M._enabled then
    return
  end

  vim.notify(msg, vim.log.levels.WARN)
end

---@param template string
---@param ... any # any number of arguments
function M.warn_fmt(template, ...)
  if not M._enabled then
    return
  end

  vim.notify(string.format(template, ...), vim.log.levels.WARN)
end

---@param msg string
function M.error(msg)
  if not M._enabled then
    return
  end

  vim.notify(msg, vim.log.levels.ERROR)
end

---@param template string
---@param ... any # any number of arguments
function M.error_fmt(template, ...)
  if not M._enabled then
    return
  end

  vim.notify(string.format(template, ...), vim.log.levels.ERROR)
end

return M
