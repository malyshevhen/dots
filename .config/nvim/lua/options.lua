---@class CustomOptions
local M = {}

function M.setup()
  -- Options
  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '

  vim.opt.signcolumn = 'yes'
  vim.cmd 'set expandtab'
  vim.cmd 'set completeopt=noselect'

  vim.opt.winborder = 'rounded'

  vim.api.nvim_set_option_value('clipboard', 'unnamed', {})

  -- set faster completion
  vim.opt.updatetime = 60

  -- disable backup file creation
  vim.opt.backup = false
  -- prevent editing of files being edited elsewhere
  vim.opt.writebackup = false

  -- Removes tilde symbols from the end of the page
  vim.opt.fillchars = { eob = ' ' }

  vim.opt.swapfile = false

  vim.opt.number = true
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
end

return M

