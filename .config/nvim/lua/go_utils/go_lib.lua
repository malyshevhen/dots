local M = {}

local log = require 'pm.utils.vim_logger'

local build_utils = require 'go_utils.build_utils'

---@type string path to the go_lib.go
local go_code_path = vim.fn.stdpath 'config' .. '/lua/go_utils/go_lib.go'
log.info('go_code_path: ' .. go_code_path)

---@type string path to the go_lib.so
local go_lib_path = vim.fn.stdpath 'config' .. '/lua/go_utils/go_lib.so'
log.info('go_lib_path: ' .. go_lib_path)

log.info 'Checking if go_lib.so exists'

local lib_exists = vim.fn.filereadable(go_lib_path) == 1
log.info('lib_exists: ' .. tostring(lib_exists))

local go_code_exists = vim.fn.filereadable(go_code_path) == 1
log.info('go_code_exists: ' .. tostring(go_code_exists))

if not lib_exists and go_code_exists then
  log.info 'Building go_lib.so'

  local ok = build_utils.build_cgo_shared_lib(go_code_path, go_lib_path)
  if not ok then
    log.error 'Failed to build go_lib.so'
    return
  end

  log.info 'Successfully built go_lib.so'
end

log.info 'Loading go_lib.so'

local ffi = require 'ffi'

ffi.cdef [[
    int AddGo(int a, int b);
]]

local go_lib = ffi.load(go_lib_path)

---@param a number
---@param b number
---@return number sum of a and b
M.add = function(a, b)
  return go_lib.AddGo(a, b)
end

return M
