local M = { 'supermaven-inc/supermaven-nvim' }

M.dependencies = { 'nvim-lua/plenary.nvim', 'onsails/lspkind.nvim' }

M.config = function()
  require('supermaven-nvim').setup {
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-h>',
      accept_word = '<C-l>',
    },
    ignore_filetypes = { cpp = true }, -- or { "cpp", }
    color = {
      suggestion_color = '#000508',
      cterm = 244,
    },
    log_level = 'off', -- set to "off" to disable logging completely
    disable_inline_completion = false, -- disables inline completion for use with cmp
    disable_keymaps = false, -- disables built in keymaps for more manual control
    condition = function()
      return false
    end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
  }
  local lspkind = require 'lspkind'
  lspkind.init {
    symbol_map = {
      Supermaven = '',
    },
  }

  vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })
end

return M
