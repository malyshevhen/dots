P:add('https://github.com/RRethy/nvim-treesitter-endwise', 'nvim-treesitter-endwise', {
  config = function()
    require('nvim-treesitter.configs').setup { endwise = { enable = true } }
  end,
})
