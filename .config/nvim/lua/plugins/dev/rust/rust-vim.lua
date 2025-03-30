local M = { 'rust-lang/rust.vim' }

M.ft = { 'rust' }

M.config = function()
  vim.g.rustfmt_autosave = 1
end

return M
