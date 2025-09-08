-- Example keybindings.lua configuration file
-- This file is automatically sourced after plugin installation
-- Keybindings are set immediately when this file is loaded

-- Set leader key if not already set
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- General keybindings
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>x', '<cmd>x<CR>', { desc = 'Save and quit' })

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = 'Next buffer' })
vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = 'Delete buffer' })

-- Window management
vim.keymap.set('n', '<leader>sh', '<cmd>split<CR>', { desc = 'Horizontal split' })
vim.keymap.set('n', '<leader>sv', '<cmd>vsplit<CR>', { desc = 'Vertical split' })
vim.keymap.set('n', '<leader>sc', '<cmd>close<CR>', { desc = 'Close window' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Go to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Go to lower window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Go to upper window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Go to right window' })

-- Better up/down movement
vim.keymap.set({ 'n', 'x' }, 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ 'n', 'x' }, 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move lines in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- Keep cursor centered when scrolling
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down and center' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up and center' })
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result and center' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result and center' })

-- Plugin-specific keybindings

-- Conform.nvim formatting
vim.keymap.set({ 'n', 'v' }, '<leader>mp', function()
  require('conform').format {
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  }
end, { desc = 'Format file or range (in visual mode)' })

-- Trouble.nvim
vim.keymap.set(
  'n',
  '<leader>xx',
  '<cmd>Trouble diagnostics toggle<CR>',
  { desc = 'Diagnostics (Trouble)' }
)
vim.keymap.set(
  'n',
  '<leader>xX',
  '<cmd>Trouble diagnostics toggle filter.buf=0<CR>',
  { desc = 'Buffer Diagnostics (Trouble)' }
)
vim.keymap.set(
  'n',
  '<leader>cs',
  '<cmd>Trouble symbols toggle focus=false<CR>',
  { desc = 'Symbols (Trouble)' }
)
vim.keymap.set(
  'n',
  '<leader>cl',
  '<cmd>Trouble lsp toggle focus=false win.position=right<CR>',
  { desc = 'LSP Definitions / references / ... (Trouble)' }
)
vim.keymap.set(
  'n',
  '<leader>xL',
  '<cmd>Trouble loclist toggle<CR>',
  { desc = 'Location List (Trouble)' }
)
vim.keymap.set(
  'n',
  '<leader>xQ',
  '<cmd>Trouble qflist toggle<CR>',
  { desc = 'Quickfix List (Trouble)' }
)

-- Gitsigns
vim.keymap.set('n', '<leader>hs', '<cmd>Gitsigns stage_hunk<CR>', { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>hr', '<cmd>Gitsigns reset_hunk<CR>', { desc = 'Reset hunk' })
vim.keymap.set('v', '<leader>hs', function()
  require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Stage hunk' })
vim.keymap.set('v', '<leader>hr', function()
  require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
end, { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>hS', '<cmd>Gitsigns stage_buffer<CR>', { desc = 'Stage buffer' })
vim.keymap.set('n', '<leader>hu', '<cmd>Gitsigns undo_stage_hunk<CR>', { desc = 'Undo stage hunk' })
vim.keymap.set('n', '<leader>hR', '<cmd>Gitsigns reset_buffer<CR>', { desc = 'Reset buffer' })
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>hb', function()
  require('gitsigns').blame_line { full = true }
end, { desc = 'Blame line' })
vim.keymap.set(
  'n',
  '<leader>tb',
  '<cmd>Gitsigns toggle_current_line_blame<CR>',
  { desc = 'Toggle line blame' }
)
vim.keymap.set('n', '<leader>hd', '<cmd>Gitsigns diffthis<CR>', { desc = 'Diff this' })
vim.keymap.set('n', '<leader>hD', function()
  require('gitsigns').diffthis '~'
end, { desc = 'Diff this ~' })
vim.keymap.set('n', '<leader>td', '<cmd>Gitsigns toggle_deleted<CR>', { desc = 'Toggle deleted' })

-- Diffview
vim.keymap.set('n', '<leader>dvo', '<cmd>DiffviewOpen<CR>', { desc = 'Open Diffview' })
vim.keymap.set('n', '<leader>dvc', '<cmd>DiffviewClose<CR>', { desc = 'Close Diffview' })
vim.keymap.set('n', '<leader>dvh', '<cmd>DiffviewFileHistory<CR>', { desc = 'File History' })

-- LSP keybindings (these will work when LSP is attached)
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = 'Go to implementation' })
vim.keymap.set('n', 'go', vim.lsp.buf.type_definition, { desc = 'Go to type definition' })
vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = 'Go to references' })
vim.keymap.set('n', 'gs', vim.lsp.buf.signature_help, { desc = 'Signature help' })
vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set({ 'n', 'x' }, '<F3>', function()
  vim.lsp.buf.format { async = true }
end, { desc = 'Format' })
vim.keymap.set('n', '<F4>', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = 'Open diagnostic float' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })

-- Diagnostic configuration
vim.keymap.set(
  'n',
  '<leader>e',
  vim.diagnostic.open_float,
  { desc = 'Show diagnostic [E]rror messages' }
)
vim.keymap.set(
  'n',
  '<leader>q',
  vim.diagnostic.setloclist,
  { desc = 'Open diagnostic [Q]uickfix list' }
)

-- Terminal mode escape
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- Clear search highlights
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})
