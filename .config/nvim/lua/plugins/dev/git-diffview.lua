local M = { 'sindrets/diffview.nvim' }

-- M.lazy = true
--
-- M.event = 'VeryLazy'

M.dependencies = {
  -- nvim-web-devicons: https://github.com/nvim-tree/nvim-web-devicons
  'nvim-tree/nvim-web-devicons',
  'nvim-lua/plenary.nvim',
}

M.config = function()
  require('diffview').setup {}

  vim.keymap.set('n', '<leader>gD', '<cmd>DiffviewOpen<cr>', { desc = 'Open Git Diff View' })
  vim.keymap.set('n', '<leader>gC', '<cmd>DiffviewClose<cr>', { desc = 'Close Git Diff View' })
end

return M
