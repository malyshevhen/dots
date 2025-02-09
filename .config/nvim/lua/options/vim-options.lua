vim.cmd 'set expandtab'
vim.cmd 'set tabstop=2'
vim.cmd 'set softtabstop=2'
vim.cmd 'set shiftwidth=2'

vim.api.nvim_set_option('clipboard', 'unnamed')

-- set faster completion
vim.opt.updatetime = 100

-- disable backup file creation
vim.opt.backup = false
-- prevent editing of files being edited elsewhere
vim.opt.writebackup = false

-- Removes tilde symbols from the end of the page
vim.opt.fillchars = { eob = ' ' }

vim.opt.swapfile = false

vim.wo.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 10

-- Nerd Fonts
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Disable line wraps
vim.opt.wrap = false

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*.go',
  callback = function()
    require('go.format').goimports()
  end,
  group = vim.api.nvim_create_augroup('goimports', {}),
})

vim.filetype.add {
  pattern = {
    ['docker-compose%.yml'] = 'yaml.docker-compose',
    ['docker-compose%.yaml'] = 'yaml.docker-compose',
    ['compose%.yml'] = 'yaml.docker-compose',
    ['compose%.yaml'] = 'yaml.docker-compose',
    ['.*/hypr/.*%.conf'] = 'hyprlang',
  },
}

vim.api.nvim_create_user_command('CopyRelPath', "call setreg('+', expand('%'))", {})

-- Hyprlang LSP
vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  pattern = { '*.hl', 'hypr*.conf' },
  callback = function(event)
    print(string.format('starting hyprls for %s', vim.inspect(event)))
    vim.lsp.start {
      name = 'hyprlang',
      cmd = { 'hyprls' },
      root_dir = vim.fn.getcwd(),
    }
  end,
})
