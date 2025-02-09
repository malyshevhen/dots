-- LSP servers and clients are able to communicate to each other what features they support.
--  By default, Neovim doesn't support everything that is in the LSP specification.
--  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
--  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend('force', capabilities, require('cmp_nvim_lsp').default_capabilities())

local path = vim.fn.stdpath 'config' .. '/spell/en.utf-8.add'
local words = {}

for word in io.open(path, 'r'):lines() do
  table.insert(words, word)
end
local util = require 'lspconfig.util'

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. Available keys are:
--  - cmd (table): Override the default command used to start the server
--  - filetypes (table): Override the default list of associated filetypes for the server
--  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
--  - settings (table): Override the default settings passed when initializing the server.
--        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
local servers = {}

-- Ansible
servers['ansiblels'] = {
  filetypes = { 'yaml.ansible' },
}

-- GOLANG LSP SETUP
servers['gopls'] = {
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
        assignVariableTypes = false,
        compositeLiteralFields = false,
        compositeLiteralTypes = false,
        constantValues = false,
        functionTypeParameters = false,
        parameterNames = false,
        rangeVariableTypes = false,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
      semanticTokens = true,
    },
  },
}

-- LUA
servers['lua_ls'] = {
  -- cmd = {...},
  -- filetypes = { ...},
  -- capabilities = {},
  settings = {
    Lua = {
      completion = {
        callSnippet = 'Replace',
      },
      -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
      -- diagnostics = { disable = { 'missing-fields' } },
      diagnostics = {
        globals = { 'vim' },
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
}

-- C, C++
servers['clangd'] = {
  settings = {
    clangd = {
      keys = {
        { '<leader>ch', '<cmd>ClangdSwitchSourceHeader<cr>', desc = 'Switch Source/Header (C/C++)' },
      },
      root_dir = function(fname)
        return require('lspconfig.util').root_pattern(
          'Makefile',
          'configure.ac',
          'configure.in',
          'config.h.in',
          'meson.build',
          'meson_options.txt',
          'build.ninja'
        )(fname) or require('lspconfig.util').root_pattern('compile_commands.json', 'compile_flags.txt')(fname) or require('lspconfig.util').find_git_ancestor(
          fname
        )
      end,
      capabilities = {
        offsetEncoding = { 'utf-16' },
      },
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy',
        '--header-insertion=iwyu',
        '--completion-style=detailed',
        '--function-arg-placeholders',
        '--fallback-style=llvm',
      },
      init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        clangdFileStatus = true,
      },
    },
  },
}

-- Python
servers['pyright'] = {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        diagnosticPublishDelay = 100,
      },
    },
  },
}

-- Cypher
servers['cypher_ls'] = {
  cmd = { 'cypher-language-server', '--stdio' },
  filetypes = { 'cypher' },
}

-- Cucumber
servers['cucumber_language_server'] = {
  filetypes = { 'cucumber', 'feature' },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find('build.gradle', { path = fname, upward = true })[1])
  end,
  settings = {
    features = { '**/src/**/*.feature', '**/resources/**/*.feature' },
    glue = { '**/src/**/*.java', '**/src/**/*.kt', '**/test/**/*.kt', '**/steps/**/*.kt' },
  },
}

-- LTex
servers['ltex'] = {
  on_attach = function(client, bufnr)
    -- your other on_attach code
    -- for example, set keymap here, like
    -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
    -- (see below code block for more details)
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
}

-- YAML
servers['yamlls'] = {
  filetypes = { 'yaml', 'yml' },
  settings = {
    yaml = {
      -- schemas = {
      --   ['https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.0/schema.yaml'] = '/*',
      -- },
      format = {
        enable = true,
        singleQuote = false,
        bracketSpacing = true,
      },
      validate = true,
      completion = true,
    },
  },
}

-- Docker
servers['dockerls'] = {}
servers['docker_compose_language_service'] = {
  filetypes = { 'yaml.docker-compose' },
  root_dir = util.root_pattern('docker-compose.yaml', 'docker-compose.yml', 'compose.yaml', 'compose.yml'),
}

-- Markdown
servers['marksman'] = {}

-- JSON
servers['jsonls'] = {}

-- Zed
servers['zls'] = {}

-- Ensure the servers and tools above are installed
--  To check the current status of installed tools and/or manually install
--  other tools, you can run
--    :Mason
--
--  You can press `g?` for help in this menu.
require('mason').setup()

-- You can add other tools here that you want Mason to install
-- for you, so that they are available from within Neovim.
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
  -- "jdtls",
})
require('mason-tool-installer').setup { ensure_installed = ensure_installed }

require('mason-lspconfig').setup {
  handlers = {
    function(server_name)
      require('lspconfig')[server_name].setup(servers[server_name] or {})
    end,
  },
}
