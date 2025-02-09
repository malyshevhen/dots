local M = { "neovim/nvim-lspconfig" }

M.dependencies = {
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim" },
  { "WhoIsSethDaniel/mason-tool-installer.nvim" },
}

M.config = function()
  require "configs.lsp.config"
end

return M
