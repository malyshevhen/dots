local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

require 'plugins.dev.lsp.config.keymaps'
require 'options.keybindings'
require 'options.vim-options'

-- put this in your main init.lua file ( before lazy setup )
vim.g.base46_cache = vim.fn.stdpath 'data' .. '/base46_cache/'

-- Declare a few options for lazy
local opts = {
  install = {
    colorscheme = { 'nvchad' },
  },
  change_detection = {
    -- Don't notify us every time a change is made to the configuration
    notify = false,
  },
  checker = {
    -- Automatically check for package updates
    enabled = true,
    -- Don't spam us with notification every time there is an update available
    notify = false,
  },
  rocks = {
    hererocks = true,
  },
}

require('lazy').setup('plugins', opts)

-- Should placed after lazy setup
for _, v in ipairs(vim.fn.readdir(vim.g.base46_cache)) do
  dofile(vim.g.base46_cache .. v)
  -- if v:match('treesitter') then
  --   -- Skip treesitter highlights, they are loaded by treesitter plugin
  -- else
  --   dofile(vim.g.base46_cache .. v)
  -- end
end
