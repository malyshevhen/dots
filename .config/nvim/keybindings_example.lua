-- Example keybindings configuration for the simplified plugin management system
-- This file shows how to convert existing keymaps to work with the new system

-- The simplified system supports the same K:map interface as before,
-- but now keymaps are set immediately when declared instead of being collected

-- Set leader key first (if not already set in options)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Basic editor keymaps
K:map {
  -- System clipboard operations (same as before)
  { map = '<leader>y', cmd = '"+y', desc = 'Yank (Clipboard)', mode = { 'v', 'x' } },
  { map = '<leader>Y', cmd = '"+Y', desc = 'Yank (Clipboard)', mode = { 'v', 'x' } },
  { map = '<leader>p', cmd = '"+p', desc = 'Paste (Clipboard)', mode = { 'v', 'x' } },
  { map = '<leader>P', cmd = '"+P', desc = 'Paste (Clipboard)', mode = { 'v', 'x' } },

  -- Window navigation (same as before)
  { map = '<c-k>', cmd = ':wincmd k<CR>', desc = 'Move to top pane' },
  { map = '<c-j>', cmd = ':wincmd j<CR>', desc = 'Move to bottom pane' },
  { map = '<c-h>', cmd = ':wincmd h<CR>', desc = 'Move to left pane' },
  { map = '<c-l>', cmd = ':wincmd l<CR>', desc = 'Move to right pane' },

  -- File operations
  { map = '<leader>w', cmd = '<cmd>w<CR>', desc = 'Save file' },
  { map = '<leader>q', cmd = '<cmd>q<CR>', desc = 'Quit' },
  { map = '<leader>o', cmd = ':update<CR> :source<CR>', desc = 'Save and source file' },

  -- LSP operations (same as before)
  { map = '<leader>cr', cmd = vim.lsp.buf.rename, desc = 'Code Rename', mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action, desc = 'Code Action', mode = { 'n', 'v' } },
}

-- Buffer navigation
K:map {
  { map = '<leader>bn', cmd = '<cmd>bnext<CR>', desc = 'Next buffer' },
  { map = '<leader>bp', cmd = '<cmd>bprevious<CR>', desc = 'Previous buffer' },
  { map = '<leader>bd', cmd = '<cmd>bdelete<CR>', desc = 'Delete buffer' },
}

-- Window management
K:map {
  { map = '<leader>sh', cmd = '<cmd>split<CR>', desc = 'Horizontal split' },
  { map = '<leader>sv', cmd = '<cmd>vsplit<CR>', desc = 'Vertical split' },
  { map = '<leader>sc', cmd = '<cmd>close<CR>', desc = 'Close window' },
  { map = '<leader>=', cmd = '<C-w>=', desc = 'Equalize windows' },
}

-- Better movement
K:map {
  -- Better up/down in wrapped lines
  {
    map = 'j',
    cmd = "v:count == 0 ? 'gj' : 'j'",
    mode = { 'n', 'x' },
    opts = { expr = true, silent = true },
  },
  {
    map = 'k',
    cmd = "v:count == 0 ? 'gk' : 'k'",
    mode = { 'n', 'x' },
    opts = { expr = true, silent = true },
  },

  -- Move lines in visual mode
  { map = 'J', cmd = ":m '>+1<CR>gv=gv", desc = 'Move line down', mode = 'v' },
  { map = 'K', cmd = ":m '<-2<CR>gv=gv", desc = 'Move line up', mode = 'v' },

  -- Keep cursor centered when scrolling
  { map = '<C-d>', cmd = '<C-d>zz', desc = 'Scroll down and center' },
  { map = '<C-u>', cmd = '<C-u>zz', desc = 'Scroll up and center' },
  { map = 'n', cmd = 'nzzzv', desc = 'Next search result and center' },
  { map = 'N', cmd = 'Nzzzv', desc = 'Previous search result and center' },
}

-- Clear search highlights
K:map {
  { map = '<Esc>', cmd = '<cmd>nohlsearch<CR>', desc = 'Clear search highlights' },
}

-- Terminal mode keymaps
K:map {
  { map = '<Esc><Esc>', cmd = '<C-\\><C-n>', desc = 'Exit terminal mode', mode = 't' },
}

-- Plugin-specific keymaps (these would typically go in plugin config files)
-- But shown here as examples of how they work with the simplified system

-- Example: If you have telescope
-- K:map {
--   { map = '<leader>ff', cmd = '<cmd>Telescope find_files<CR>', desc = 'Find files' },
--   { map = '<leader>fg', cmd = '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
--   { map = '<leader>fb', cmd = '<cmd>Telescope buffers<CR>', desc = 'Find buffers' },
--   { map = '<leader>fh', cmd = '<cmd>Telescope help_tags<CR>', desc = 'Help tags' },
-- }

-- Example: Diagnostic keymaps
K:map {
  { map = '<leader>e', cmd = vim.diagnostic.open_float, desc = 'Show diagnostic error messages' },
  { map = '<leader>E', cmd = vim.diagnostic.setloclist, desc = 'Open diagnostic quickfix list' },
  { map = '[d', cmd = vim.diagnostic.goto_prev, desc = 'Previous diagnostic' },
  { map = ']d', cmd = vim.diagnostic.goto_next, desc = 'Next diagnostic' },
}

-- Example: LSP keymaps (these are set globally, but could be buffer-local)
K:map {
  { map = 'gd', cmd = vim.lsp.buf.definition, desc = 'Go to definition' },
  { map = 'gD', cmd = vim.lsp.buf.declaration, desc = 'Go to declaration' },
  { map = 'gi', cmd = vim.lsp.buf.implementation, desc = 'Go to implementation' },
  { map = 'go', cmd = vim.lsp.buf.type_definition, desc = 'Go to type definition' },
  { map = 'gr', cmd = vim.lsp.buf.references, desc = 'Go to references' },
  { map = 'gs', cmd = vim.lsp.buf.signature_help, desc = 'Signature help' },
  { map = '<F2>', cmd = vim.lsp.buf.rename, desc = 'Rename symbol' },
  {
    map = '<F3>',
    cmd = function()
      vim.lsp.buf.format { async = true }
    end,
    desc = 'Format code',
    mode = { 'n', 'x' },
  },
  { map = '<F4>', cmd = vim.lsp.buf.code_action, desc = 'Code action' },
}

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('simple-pm-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Note: The key difference with the simplified system is that:
-- 1. All K:map calls set keymaps IMMEDIATELY when this file is sourced
-- 2. No collection/batching happens - each K:map call processes its keymaps right away
-- 3. The same syntax works, but the implementation is much simpler
-- 4. Validation and error checking still happens for each keymap
