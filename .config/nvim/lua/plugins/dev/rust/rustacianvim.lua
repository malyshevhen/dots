local M = { 'mrcjkb/rustaceanvim' }

M.ft = { 'rust' }

M.version = '^4'

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'mfussenegger/nvim-dap',
  {
    'lvimuser/lsp-inlayhints.nvim',
    opts = {},
  },
}

M.config = function()
  vim.g.rustaceanvim = {
    inlay_hints = {
      highlight = 'NonText',
    },
    tools = {
      hover_actions = {
        auto_focus = true,
      },
    },
    server = {
      on_attach = function(client, bufnr)
        require('lsp-inlayhints').on_attach(client, bufnr)
      end,
    },
  }
end

return M
