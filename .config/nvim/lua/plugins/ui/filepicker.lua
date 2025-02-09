-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

local neo_tree = {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\',        ':Neotree toggle<CR>', { desc = 'NeoTree toggle' } },
    { '<leader>e', ':Neotree reveal<CR>', { desc = 'NeoTree reveal' } },
  },
  opts = {
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}

local nvim_tree = {
  'nvim-tree/nvim-tree.lua',
  version = '*',
  lazy = false,
  dependencies = {
    'nvim-tree/nvim-web-devicons',
  },
  keys = {
    { '\\',        ':NvimTreeToggle<CR>', { desc = 'NeoTree toggle' } },
    { '<leader>e', ':NvimTreeFindFile<CR>', { desc = 'NeoTree reveal' } },
  },
  config = function()
    require('nvim-tree').setup {}
  end,
}

return nvim_tree
