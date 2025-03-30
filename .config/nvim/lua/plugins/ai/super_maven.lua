local M = { 'supermaven-inc/supermaven-nvim' }

M.dependencies = { 'nvim-lua/plenary.nvim', 'onsails/lspkind.nvim' }

M.config = function()
  require('supermaven-nvim').setup {}
  local lspkind = require 'lspkind'
  lspkind.init {
    symbol_map = {
      Supermaven = '',
    },
  }

  vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })
end

return M
