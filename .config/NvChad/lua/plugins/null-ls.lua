local M = { "nvimtools/none-ls.nvim" }

M.lazy = false

M.dependencies = { -- optional packages
  "nvim-lua/plenary.nvim",
  "nvim-lua/popup.nvim",
  "nvim-lua/lsp-status.nvim",
  "nvim-lua/completion-nvim",
  "nvim-lua/lsp_extensions.nvim",
  "ray-x/lsp_signature.nvim",
}

M.config = function()
  local null_ls = require "null-ls"
  -- local cspell = require 'cspell'

  null_ls.setup {
    sources = {
      -- LUA
      null_ls.builtins.formatting.stylua,

      -- JAVA
      null_ls.builtins.formatting.google_java_format,

      -- YAML
      null_ls.builtins.diagnostics.hadolint,

      -- Markdown
      null_ls.builtins.diagnostics.markdownlint_cli2,
    },
  }
end

return M
