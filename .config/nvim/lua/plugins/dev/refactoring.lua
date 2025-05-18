local M = { 'ThePrimeagen/refactoring.nvim' }

M.event = { 'BufReadPre', 'BufNewFile' }

M.lazy = false

M.dependencies = {
  'nvim-lua/plenary.nvim',
  'nvim-treesitter/nvim-treesitter',
}

local opts = {
  prompt_func_return_type = {
    go = true,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },

  prompt_func_param_type = {
    go = true,
    java = false,
    cpp = false,
    c = false,
    h = false,
    hpp = false,
    cxx = false,
  },

  printf_statements = {},
  print_var_statements = {},
  show_success_message = true, -- shows a message with information about the refactor on success
  -- i.e. [Refactor] Inlined 3 variable occurrences
}

local function map(keymap, cmd)
  vim.keymap.set({ 'n', 'x' }, keymap, function()
    return require('refactoring').refactor(cmd)
  end, { expr = true })
end

-- stylua: ignore
M.config = function()
  require('refactoring').setup(opts)

  map("<leader>re", "Extract Function")
  map("<leader>rf", "Extract Function To File")
  map("<leader>rv", "Extract Variable")
  map("<leader>rI", "Inline Function")
  map("<leader>ri", "Inline Variable")

  map("<leader>rbb", "Extract Block")
  map("<leader>rbf", "Extract Block To File")
end

return M
