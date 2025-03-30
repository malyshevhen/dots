local M = { 'echasnovski/mini.nvim' }

M.config = function()
  require('mini.pairs').setup {}
  require('mini.surround').setup {}
  require('mini.ai').setup {}
  require('mini.move').setup {}
  require('mini.operators').setup {}
  require('mini.comment').setup {}
  require('mini.jump').setup {}
end

return M
