local M = { 'neovim/nvim-lspconfig' }

M.dependencies = {
  { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
  { 'williamboman/mason-lspconfig.nvim' },
  { 'WhoIsSethDaniel/mason-tool-installer.nvim' },
  { 'folke/neodev.nvim', opts = {} },
  { 'onsails/lspkind.nvim' },
}

local path = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'
local words = {}
for word in io.open(path, 'r'):lines() do
  table.insert(words, word)
end

local servers = {
  -- Ansible
  ['ansiblels'] = {
    filetypes = { 'yaml.ansible' },
  },

  -- Go
  ['gopls'] = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    settings = {
      gopls = {
        gofumpt = true,
        codelenses = {
          gc_details = false,
          generate = true,
          regenerate_cgo = true,
          run_govulncheck = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          vendor = true,
        },
        hints = {
          assignVariableTypes = true,
          compositeLiteralFields = false,
          compositeLiteralTypes = false,
          constantValues = true,
          functionTypeParameters = false,
          parameterNames = false,
          rangeVariableTypes = false,
        },
        analyses = {
          nilness = true,
          unusedparams = true,
          unusedwrite = true,
          useany = true,
        },
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
        directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
        semanticTokens = true,
      },
    },
  },

  -- LUA
  ['lua_ls'] = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
        diagnostics = {
          globals = { 'vim' },
          disable = { 'missing-fields' },
        },
        workspace = {
          library = {
            vim.fn.expand '$VIMRUNTIME/lua',
            vim.fn.expand '$VIMRUNTIME/lua/vim/lsp',
            vim.fn.stdpath 'data' .. '/lazy/ui/nvchad_types',
            vim.fn.stdpath 'data' .. '/lazy/lazy.nvim/lua/lazy',
            '${3rd}/luv/library',
          },
          maxPreload = 100000,
          preloadFileSize = 10000,
        },
      },
    },
  },

  -- Elixir
  -- ['elixirls'] = {},

  -- Python
  ['pyright'] = {
    settings = {
      python = {
        analysis = {
          ignore = { '*' },
        },
      },
      pyright = {
        -- Using Ruff's import organizer
        disableOrganizeImports = true,
      },
    },
  },
  ['ruff'] = {
    settings = {
      logLevel = 'debug',
    },
  },

  -- Cypher
  ['cypher_ls'] = {
    cmd = { 'cypher-language-server', '--stdio' },
    filetypes = { 'cypher' },
  },

  -- Cucumber
  ['cucumber_language_server'] = {
    filetypes = { 'cucumber', 'feature' },
    root_dir = function(fname)
      return vim.fs.dirname(vim.fs.find('build.gradle', { path = fname, upward = true })[1])
    end,
    settings = {
      features = { '**/src/**/*.feature', '**/resources/**/*.feature' },
      glue = { '**/src/**/*.java', '**/src/**/*.kt', '**/test/**/*.kt', '**/steps/**/*.kt' },
    },
  },

  -- LTex
  ['ltex'] = {
    on_attach = function(_, bufnr)
      require('ltex-utils').on_attach(bufnr)
    end,
    settings = {
      ltex = {
        disabledRules = {
          ['en-US'] = { 'PROFANITY' },
          ['en-GB'] = { 'PROFANITY' },
        },
        dictionary = {
          ['en-US'] = words,
          ['en-GB'] = words,
        },
      },
    },
  },

  -- YAML
  ['yamlls'] = {
    filetypes = { 'yaml', 'yml' },
    settings = {
      yaml = {
        format = {
          enable = true,
          singleQuote = false,
          bracketSpacing = true,
        },
        validate = true,
        completion = true,
      },
    },
  },

  -- Markdown
  ['marksman'] = {},

  -- JSON
  ['jsonls'] = {},

  -- Zed
  ['zls'] = {},

  -- Bash
  ['bashls'] = {},
}

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  'stylua',
  'gofumpt',
  'impl',
  'goimports',
  'delve',
  'gomodifytags',
  'hadolint',
  'markdownlint-cli2',
  'markdown-toc',
  'rust_analyzer',
  'flake8',
  'black',
  'codelldb',
  'cspell',
  'shellcheck',
  'shfmt',
  'sleek',
})

M.config = function()
  -- setup() is also available as an alias
  require('lspkind').init {
    -- defines how annotations are shown
    -- default: symbol
    -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
    mode = 'symbol_text',

    -- default symbol map
    -- can be either 'default' (requires nerd-fonts font) or
    -- 'codicons' for codicon preset (requires vscode-codicons font)
    --
    -- default: 'default'
    preset = 'codicons',

    -- override preset symbols
    --
    -- default: {}
    symbol_map = {
      Text = '󰉿',
      Method = '󰆧',
      Function = '󰊕',
      Constructor = '',
      Field = '󰜢',
      Variable = '󰀫',
      Class = '󰠱',
      Interface = '',
      Module = '',
      Property = '󰜢',
      Unit = '󰑭',
      Value = '󰎠',
      Enum = '',
      Keyword = '󰌋',
      Snippet = '',
      Color = '󰏘',
      File = '󰈙',
      Reference = '󰈇',
      Folder = '󰉋',
      EnumMember = '',
      Constant = '󰏿',
      Struct = '󰙅',
      Event = '',
      Operator = '󰆕',
      TypeParameter = '',
    },
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

  require('mason').setup()
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  local on_attach = function(client, bufnr)
    local nmmap = function(keys, func, desc)
      vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
    end

    if client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup(string.format('LspHighlight-%d', bufnr), { clear = true })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = bufnr,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    if client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
      nmmap('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
      end, '[T]oggle Inlay [H]ints')
    end

    if client.name == 'gopls' and not client.server_capabilities.semanticTokensProvider then
      local semantic = client.config.capabilities.textDocument.semanticTokens
      if semantic then
        client.server_capabilities.semanticTokensProvider = {
          full = true,
          legend = { tokenModifiers = semantic.tokenModifiers, tokenTypes = semantic.tokenTypes },
          range = true,
        }
      end
    end

    if client.name == 'ruff' then
      client.server_capabilities.hoverProvider = false
    end
  end

  local lspconfig = require 'lspconfig'

  -- Configure servers from the `servers` table
  for server_name, server_opts in pairs(servers) do
    -- Make a deep copy to avoid modifying the original table
    local opts = vim.deepcopy(server_opts)

    -- Combine on_attach functions
    local original_on_attach = opts.on_attach
    opts.on_attach = function(client, bufnr)
      if original_on_attach then
        original_on_attach(client, bufnr)
      end
      on_attach(client, bufnr)
    end

    -- Set capabilities
    opts.capabilities = vim.tbl_deep_extend('force', capabilities, opts.capabilities or {})

    lspconfig[server_name].setup(opts)
  end

  -- Setup for other servers not in the table
  lspconfig.gleam.setup {
    on_attach = on_attach,
    capabilities = capabilities,
  }
end

-- stylua: ignore
M.keys = {
  { 'gD',         vim.lsp.buf.declaration, desc = '[G]oto [D]eclaration', mode = { 'n' } },
  { '<leader>cr', vim.lsp.buf.rename,      desc = '[C]ode [R]ename',      mode = { 'n' } },
  { '<leader>ca', vim.lsp.buf.code_action, desc = '[C]ode [A]ction',      mode = { 'n', 'v' } },
}

return M
