-- Example plugins.lua configuration file
-- This file is automatically sourced after plugin installation
-- Configure your plugins here

-- Example: Configure alpha-nvim (dashboard)
local alpha = require 'alpha'
local dashboard = require 'alpha.themes.dashboard'

dashboard.section.header.val = {
  '                                                     ',
  '  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ',
  '  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ',
  '  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ',
  '  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ',
  '  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ',
  '  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ',
  '                                                     ',
}

dashboard.section.buttons.val = {
  dashboard.button('f', '  Find file', ':Telescope find_files <CR>'),
  dashboard.button('e', '  New file', ':ene <BAR> startinsert <CR>'),
  dashboard.button('r', '  Recently used files', ':Telescope oldfiles <CR>'),
  dashboard.button('t', '  Find text', ':Telescope live_grep <CR>'),
  dashboard.button('c', '  Configuration', ':e $MYVIMRC <CR>'),
  dashboard.button('q', '  Quit Neovim', ':qa<CR>'),
}

alpha.setup(dashboard.opts)

-- Example: Configure autopairs
require('nvim-autopairs').setup {
  check_ts = true,
  ts_config = {
    lua = { 'string' },
    javascript = { 'template_string' },
  },
}

-- Example: Configure conform.nvim (formatting)
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'black' },
    javascript = { 'prettier' },
    typescript = { 'prettier' },
    go = { 'gofmt' },
  },
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
}

-- Example: Configure rose-pine theme
vim.cmd 'colorscheme rose-pine'

-- Example: Configure treesitter
require('nvim-treesitter.configs').setup {
  ensure_installed = {
    'lua',
    'python',
    'javascript',
    'typescript',
    'go',
    'rust',
    'elixir',
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
}

-- Example: Configure gitsigns
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- Example: Configure trouble.nvim
require('trouble').setup {
  icons = false,
  fold_open = 'v',
  fold_closed = '>',
  indent_lines = false,
  signs = {
    error = 'error',
    warning = 'warn',
    information = 'info',
    hint = 'hint',
    other = 'other',
  },
}

-- Example: Configure blink.cmp
require('blink.cmp').setup {
  keymap = {
    show = '<C-space>',
    hide = '<C-e>',
    accept = '<Tab>',
    select_prev = { '<Up>', '<C-p>' },
    select_next = { '<Down>', '<C-n>' },
    show_documentation = '<C-space>',
    hide_documentation = '<C-space>',
    scroll_documentation_up = '<C-b>',
    scroll_documentation_down = '<C-f>',
  },
}
