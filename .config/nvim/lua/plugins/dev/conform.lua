local M = { 'stevearc/conform.nvim' }

M.opts = {}

M.config = function()
  require('conform').setup {
    formatters_by_ft = {
      lua = { 'stylua', lsp_format = 'last' },
      -- Conform will run multiple formatters sequentially
      python = { 'isort', 'black' },
      -- You can customize some of the format options for the filetype (:help conform.format)
      rust = { 'rustfmt', lsp_format = 'fallback' },
      -- Conform will run the first available formatter
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      -- Conform will run multiple formatters sequentially
      go = { 'goimports', 'gofmt' },
      -- Java
      java = { 'google-java-format' },
      -- Bash
      sh = { 'shfmt' },
      -- SQL
      -- sql = { 'sleek' },
      -- Gleam
      gleam = { 'gleam format', lsp_format = 'fallback' },
      -- Elixir
      elixir = { 'mix format', lsp_format = 'fallback' },
    },

    format_on_save = {
      -- These options will be passed to conform.format()
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
  }
end

-- stylua: ignore
M.keys = function()
  return {
    { "<leader>cf", require('conform').format, desc = '[C]ode [F]ormat' },
  }
end

return M
