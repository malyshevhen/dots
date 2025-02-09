local M = { "VidocqH/lsp-lens.nvim" }

M.lazy = false

M.config = function()
  require("lsp-lens").setup {}
end

return M
