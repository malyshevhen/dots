vim.bo.expandtab = true
vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2
vim.bo.tabstop = 2

require('elixir').setup {
  opts = {
    nextls = { enable = false },
    elixirls = { enable = true },
    projectionist = { enable = true },
  },
}

-- stylua: ignore
K:map {
  { map = '<leader>fp', cmd = '<cmd>ElixirFromPipe<cr>',    desc = 'Convert from pipe',   mode = 'n' },
  { map = '<leader>tp', cmd = '<cmd>ElixirToPipe<cr>',      desc = 'Convert to pipe',     mode = 'n' },
  { map = '<leader>em', cmd = '<cmd>ElixirExpandMacro<cr>', desc = 'Expand macro',        mode = 'v' },
  { map = '<leader>er', cmd = '<cmd>ElixirRestart<cr>',     desc = 'Restart Elixir LS',   mode = 'n' },
  { map = '<leader>eo', cmd = '<cmd>ElixirOutputPanel<cr>', desc = 'Toggle output panel', mode = 'n' },
}
