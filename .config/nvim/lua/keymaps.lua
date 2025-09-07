-- stylua: ignore
K:map {
  -- System clipboard operations
  { map = '<leader>y',  cmd = '"+y',                     desc = 'Yank (Clipboard)',    mode = { 'v', 'x' } },
  { map = '<leader>Y',  cmd = '"+Y',                     desc = 'Yank (Clipboard)',    mode = { 'v', 'x' } },
  { map = '<leader>p',  cmd = '"+p',                     desc = 'Paste (Clipboard)',   mode = { 'v', 'x' } },
  { map = '<leader>P',  cmd = '"+P',                     desc = 'Paste (Clipboard)',   mode = { 'v', 'x' } },

  -- Window navigation
  { map = '<c-k>',      cmd = ':wincmd k<CR>',           desc = 'Move to top pane' },
  { map = '<c-j>',      cmd = ':wincmd j<CR>',           desc = 'Move to bottom pane' },
  { map = '<c-h>',      cmd = ':wincmd h<CR>',           desc = 'Move to left pane' },
  { map = '<c-l>',      cmd = ':wincmd l<CR>',           desc = 'Move to right pane' },
  { map = '<leader>o',  cmd = ':update<CR> :source<CR>', desc = 'Save and source file' },

  -- LSP operations
  { map = '<leader>cr', cmd = vim.lsp.buf.rename,        desc = 'Code Rename',         mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action,   desc = 'Code Action',         mode = { 'n', 'v' } },
}
