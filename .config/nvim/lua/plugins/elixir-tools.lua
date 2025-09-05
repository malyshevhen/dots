local Plug = require('types').Plug

return Plug.new('https://github.com/elixir-tools/elixir-tools.nvim', 'elixir-tools.nvim', {
  opts = {
    credo = {
      enable = true,
    },
    elixirls = {
      enable = true,
      settings = {
        dialyzerEnabled = false,
        enableTestLenses = false,
      },
    },
    nextls = {
      enable = false,
    },
  },
  config = function()
    local elixir = require 'elixir'
    local elixirls = require 'elixir.elixirls'

    elixir.setup {
      nextls = {
        enable = false,
      },
      credo = {
        enable = true,
      },
      elixirls = {
        enable = true,
        settings = {
          dialyzerEnabled = false,
          enableTestLenses = false,
          fetchDeps = false,
          mixEnv = 'dev',
          projectDir = '',
        },
        on_attach = function(client, bufnr)
          vim.keymap.set('n', '<space>fp', ':ElixirFromPipe<cr>', { buffer = true, noremap = true })
          vim.keymap.set('n', '<space>tp', ':ElixirToPipe<cr>', { buffer = true, noremap = true })
          vim.keymap.set('v', '<space>em', ':ElixirExpandMacro<cr>', { buffer = true, noremap = true })
        end,
      },
    }
  end,
  keymaps = {
    {
      map = '<leader>fp',
      cmd = '<cmd>ElixirFromPipe<cr>',
      desc = 'Convert from pipe',
      mode = 'n',
    },
    {
      map = '<leader>tp',
      cmd = '<cmd>ElixirToPipe<cr>',
      desc = 'Convert to pipe',
      mode = 'n',
    },
    {
      map = '<leader>em',
      cmd = '<cmd>ElixirExpandMacro<cr>',
      desc = 'Expand macro',
      mode = 'v',
    },
    {
      map = '<leader>er',
      cmd = '<cmd>ElixirRestart<cr>',
      desc = 'Restart Elixir LS',
      mode = 'n',
    },
    {
      map = '<leader>eo',
      cmd = '<cmd>ElixirOutputPanel<cr>',
      desc = 'Toggle output panel',
      mode = 'n',
    },
  },
})
