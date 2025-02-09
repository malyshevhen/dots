require "nvchad.options"

-- add yours here!

local o = vim.o

-- o.spelllang = "en_us"
-- o.spell = true

-- set faster completion
o.updatetime = 100

-- disable backup file creation
o.backup = false
-- prevent editing of files being edited elsewhere
o.writebackup = false

-- Removes tilde symbols from the end of the page
-- o.fillchars = { eob = ' ' }

o.swapfile = false

o.relativenumber = true

o.scrolloff = 30

-- Enable mouse mode, can be useful for resizing splits for example!
o.mouse = 'a'

-- Save undo history
o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

-- Show which line your cursor is on
o.cursorline = true

-- Disable line wraps
o.wrap = false

o.cursorlineopt ='both' -- to enable cursorline!

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local format_sync_grp = vim.api.nvim_create_augroup('goimports', {})
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    require('go.format').goimports()
  end,
  group = format_sync_grp,
})

vim.filetype.add {
  pattern = {
    ['docker-compose%.yml'] = 'yaml.docker-compose',
    ['docker-compose%.yaml'] = 'yaml.docker-compose',
    ['compose%.yml'] = 'yaml.docker-compose',
    ['compose%.yaml'] = 'yaml.docker-compose',
  },
}

vim.api.nvim_set_option('clipboard', 'unnamed')

-- Nerd Fonts
vim.g.have_nerd_font = true

vim.wo.number = true

vim.cmd 'set expandtab'
vim.cmd 'set tabstop=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set shiftwidth=2'

vim.api.nvim_create_autocmd("BufDelete", {
  callback = function()
    local bufs = vim.t.bufs
    if #bufs == 1 and vim.api.nvim_buf_get_name(bufs[1]) == "" then
      vim.cmd "Nvdash"
    end
  end,
})
