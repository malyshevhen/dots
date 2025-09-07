P:add('https://github.com/kevinhwang91/nvim-ufo', 'ufo', {
  deps = { 'https://github.com/kevinhwang91/promise-async' },

  opts = {
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
  },

  config = function()
    vim.o.foldcolumn = '1'
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
})

-- stylua: ignore
K:map {
  { map = 'zR', cmd = function() require('ufo').openAllFolds() end,  desc = 'Open all folds', },
  { map = 'zM', cmd = function() require('ufo').closeAllFolds() end, desc = 'Close all folds', },
}
