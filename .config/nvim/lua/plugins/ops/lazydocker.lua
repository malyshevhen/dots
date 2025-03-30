local M = { 'crnvl96/lazydocker.nvim' }

M.event = 'VeryLazy'

M.opts = {}

M.dependencies = {
  'MunifTanjim/nui.nvim',
}

-- stylua: ignore
M.keys = {
  { '<leader>ld', '<cmd>LazyDocker<cr>', desc = 'LazyDocker' },
}

return M
