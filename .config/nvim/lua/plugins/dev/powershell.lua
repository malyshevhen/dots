local M = {
  'TheLeoP/powershell.nvim',
}

local opts = {
  bundle_path = vim.fn.stdpath 'data' .. '/mason/packages/powershell-editor-services',
}

M.config = function()
  require('powershell').setup(opts)
end

return M
