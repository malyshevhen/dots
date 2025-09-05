return Plug.new('https://github.com/stevearc/conform.nvim', 'conform', {
  opts = {
    formatters_by_ft = {
      lua = { 'stylua', lsp_format = 'first' },
      rust = { 'rustfmt', lsp_format = 'fallback' },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      typescript = { 'prettierd', 'prettier', stop_after_first = true },
      javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
      go = { 'goimports', 'gofmt' },
      java = { 'google-java-format' },
      sh = { 'shfmt' },
      bash = { 'shfmt' },
      zsh = { 'shfmt' },
      gleam = { 'gleam format', lsp_format = 'fallback' },
      elixir = { 'mix format', lsp_format = 'fallback' },
      python = { 'ruff_format', 'ruff_fix', 'ruff_imports', lsp_format = 'fallback' },
      toml = { 'taplo' },
      yaml = { 'prettierd', 'prettier', stop_after_first = true },
      json = { 'prettierd', 'prettier', stop_after_first = true },
      markdown = { 'prettierd', 'prettier', stop_after_first = true },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      scss = { 'prettierd', 'prettier', stop_after_first = true },
      c = { 'clang-format' },
      cpp = { 'clang-format' },
    },
    format_on_save = {
      timeout_ms = 500,
      lsp_format = 'fallback',
    },
    default_format_opts = {
      lsp_format = 'fallback',
    },
  },

  config = function(opts)
    require('conform').setup(opts)

    -- Format on save autocmd
    vim.api.nvim_create_autocmd('BufWritePre', {
      pattern = '*',
      callback = function(args)
        require('conform').format {
          bufnr = args.buf,
          async = false,
          timeout_ms = 500,
        }
      end,
    })
  end,

  -- stylua: ignore
  keymaps = {
    { map = '<leader>cf', cmd = function() require('conform').format() end,                desc = 'Code (Conform) format', mode = { 'n', 'v', 'x' }, },
    { map = '<leader>cF', cmd = function() require('conform').format { async = true } end, desc = 'Format async',          mode = { 'n', 'v', 'x' }, },
  },
})
