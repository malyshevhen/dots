return {
  'jhofscheier/ltex-utils.nvim',
  dependencies = {
    'neovim/nvim-lspconfig',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('ltex-utils').setup({})
  end,
}
