local M = { 'folke/todo-comments.nvim' }

M.dependencies = { 'nvim-lua/plenary.nvim' }

M.event = 'VimEnter'

M.opts = { signs = false }

-- stylua: ignore
M.keys = {
  { ']t',         function() require('todo-comments').jump_next() end,              desc = 'Next Todo Comment', },
  { '[t',         function() require('todo-comments').jump_prev() end,              desc = 'Previous Todo Comment', },
  { '<leader>xt', '<cmd>Trouble todo toggle<cr>',                                   desc = 'Todo (Trouble)' },
  { '<leader>xT', '<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>', desc = 'Todo/Fix/Fixme (Trouble)' },
}

return M
