local M = {}

local log = require 'utils.vim_logger'

---Build the library using the go compile.
---
---example:
--- ```sh
--- go build -o go_lib.so -buildmode=c-shared go_lib.go
---
--- ```
---@param in_path string path to the go_lib.go
---@param out_path string path to the go_lib.so
---@return boolean ok if the build was successful
M.build_cgo_shared_lib = function(in_path, out_path)
  local cmd = {
    'go',
    'build',
    '-o',
    out_path,
    '-buildmode=c-shared',
    in_path,
  }

  local ok, result = pcall(vim.fn.system, cmd)
  if not ok then
    log.error_fmt('Failed to build [%s] cgo library:\n%s', in_path, result)
    return false
  end
  log.info_fmt('Successfully built [%s] cgo library:\n%s', in_path, result)

  return true
end

return M
