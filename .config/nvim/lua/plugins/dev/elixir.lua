local M = { 'elixir-tools/elixir-tools.nvim' }

M.version = '*'

M.event = { 'BufReadPre', 'BufNewFile' }

M.config = function()
  local elixir = require 'elixir'
  local elixirls = require 'elixir.elixirls'

  elixir.setup {
    nextls = { enabled = false },
    elixirls = {
      enabled = true,

      settings = elixirls.settings {
        dialyzerEnabled = true,
        fetchDeps = true,
        enableTestLenses = true,
        suggestSpecs = true,
      },
      on_attach = function(client, bufnr)
        vim.keymap.set('n', '<space>fp', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
        vim.keymap.set('n', '<space>tp', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
        vim.keymap.set('v', '<space>em', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })
      end,
    },
    projectionist = {
      enable = true,
    },
  }
end

M.dependencies = {
  'nvim-lua/plenary.nvim',
}

return M
