-- WARN: Cause issue: to many files opened
local M = { 'kevinhwang91/nvim-ufo' }

M.dependencies = { 'kevinhwang91/promise-async' }

M.config = function()
  vim.o.foldcolumn = '1' -- '0' is not bad
  vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
  vim.o.foldlevelstart = 99
  vim.o.foldenable = true

  -- Using ufo provider need remap `zR` and `zM`. If Neovim is 0.6.1, remap yourself

  -- (Note: the `nvim-treesitter` plugin is *not* needed.)
  -- ufo uses the same query files for folding (queries/<lang>/folds.scm)
  -- performance and stability are better than `foldmethod=nvim_treesitter#foldexpr()`
  require('ufo').setup {
    provider_selector = function(bufnr, filetype, buftype)
      return { 'treesitter', 'indent' }
    end,
  }
end

-- stylua: ignore
M.keys = function()
  return {
    { 'zR', require('ufo').openAllFolds,  desc = 'Open All Folds' },
    { 'zM', require('ufo').closeAllFolds, desc = 'Close All Folds' },
  }
end

return M
