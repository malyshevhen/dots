local M = { 'nvim-treesitter/nvim-treesitter' }

M.build = ':TSUpdate'

M.opts = {
  ensure_installed = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'vim',
    'vimdoc',
    'java',
    'groovy',
    'xml',
    'go',
    'gomod',
    'gosum',
    'git_config',
    'gitcommit',
    'git_rebase',
    'gitignore',
    'gitattributes',
    'zig',
    'elixir',
  },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = true,
  },
  indent = { enable = true, disable = { 'ruby' } },
}

M.config = function(_, opts)
  -- Prefer git instead of curl in order to improve connectivity in some environments
  require('nvim-treesitter.install').prefer_git = true
  ---@diagnostic disable-next-line: missing-fields
  require('nvim-treesitter.configs').setup(opts)
end

return M
