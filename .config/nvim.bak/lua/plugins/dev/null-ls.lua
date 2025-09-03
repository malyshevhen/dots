local M = {
  'nvimtools/none-ls.nvim',
}

M.dependencies = { -- optional packages
  'nvim-lua/plenary.nvim',
  'nvim-lua/popup.nvim',
  'nvim-lua/lsp-status.nvim',
  'nvim-lua/completion-nvim',
  'nvim-lua/lsp_extensions.nvim',
  'ray-x/lsp_signature.nvim',
  'davidmh/cspell.nvim',
}

M.config = function()
  local null_ls = require 'null-ls'
  local cspell = require 'cspell'

  null_ls.setup {
    sources = {
      -- cspell
      cspell.diagnostics,
      cspell.code_actions,

      -- Lua
      null_ls.builtins.formatting.stylua,

      -- Java
      null_ls.builtins.formatting.google_java_format,
      -- null_ls.builtins.diagnostics.checkstyle.with {
      --   extra_args = { '-c', '/google_checks.xml' },
      -- },

      -- YAML
      null_ls.builtins.diagnostics.hadolint,

      -- Markdown
      null_ls.builtins.diagnostics.markdownlint_cli2,

      -- Python3
      -- null_ls.builtins.diagnostics.flake8,
      null_ls.builtins.formatting.black,
    },
  }
end

return M
