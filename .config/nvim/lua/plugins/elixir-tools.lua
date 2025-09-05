return Plug.new('https://github.com/elixir-tools/elixir-tools.nvim', 'elixir', {
  opts = {
    nextls = { enable = false },
    elixirls = { enable = true },
    projectionist = { enable = true },
  },

  -- stylua: ignore
  keymaps = {
    { map = '<leader>fp', cmd = '<cmd>ElixirFromPipe<cr>',    desc = 'Convert from pipe',   mode = 'n' },
    { map = '<leader>tp', cmd = '<cmd>ElixirToPipe<cr>',      desc = 'Convert to pipe',     mode = 'n' },
    { map = '<leader>em', cmd = '<cmd>ElixirExpandMacro<cr>', desc = 'Expand macro',        mode = 'v' },
    { map = '<leader>er', cmd = '<cmd>ElixirRestart<cr>',     desc = 'Restart Elixir LS',   mode = 'n' },
    { map = '<leader>eo', cmd = '<cmd>ElixirOutputPanel<cr>', desc = 'Toggle output panel', mode = 'n' },
  },
})
