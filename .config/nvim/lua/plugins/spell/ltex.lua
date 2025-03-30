local M = { 'jhofscheier/ltex-utils.nvim' }

M.dependencies = {
  'neovim/nvim-lspconfig',
  'nvim-telescope/telescope.nvim',
}

M.config = function()
  require('ltex-utils').setup {}
end

return M
