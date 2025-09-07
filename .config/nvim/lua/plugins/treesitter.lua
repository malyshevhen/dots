P:add('https://github.com/nvim-treesitter/nvim-treesitter', 'nvim-treesitter', {
  config = function()
    local ts_update = require('nvim-treesitter.install').update { with_sync = true }
    ts_update()

    require('nvim-treesitter.configs').setup {
      ensure_installed = {
        'c',
        'lua',
        'vim',
        'vimdoc',
        'query',
        'elixir',
        'heex',
        'javascript',
        'html',
        'go',
        'gomod',
        'gosum',
        'git_config',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'diff',
        'zig',
        'markdown',
        'python',
      },
      sync_install = false,
      highlight = { enable = true },
      indent = { enable = true },
      auto_install = true,
    }
  end,
})
