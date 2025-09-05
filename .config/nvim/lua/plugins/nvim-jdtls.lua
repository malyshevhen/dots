return Plug.new('https://github.com/mfussenegger/nvim-jdtls', 'nvim-jdtls', {
  deps = {
    'https://github.com/nvim-lua/plenary.nvim',
  },

  config = function()
    -- Setup JDTLS for Java files only when needed
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        -- Only require jdtls when we actually need it
        local ok, jdtls = pcall(require, 'jdtls')
        if not ok then
          vim.notify('Failed to load nvim-jdtls: ' .. tostring(jdtls), vim.log.levels.WARN)
          return
        end

        -- Function to detect the OS
        local function get_os_config()
          if vim.fn.has 'mac' == 1 then
            return 'mac'
          elseif vim.fn.has 'unix' == 1 then
            return 'linux'
          else
            return 'win'
          end
        end

        -- Function to get workspace directory
        local function get_workspace_dir()
          local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
          local workspace_dir = vim.fn.stdpath 'data' .. '/jdtls-workspace/' .. project_name
          return workspace_dir
        end

        -- Find root directory
        local root_dir = require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }

        -- Determine the OS config directory
        local os_config = get_os_config()

        -- Use the jdtls command we installed
        local cmd
        if vim.fn.executable 'jdtls' == 1 then
          -- Ensure workspace directory exists
          local workspace = get_workspace_dir()
          vim.fn.mkdir(workspace, 'p')
          cmd = { 'jdtls', '-data', workspace }
        else
          vim.notify('JDTLS not found. Please install eclipse.jdt.ls', vim.log.levels.ERROR)
          return
        end

        -- JDTLS configuration
        local config = {
          cmd = cmd,
          root_dir = root_dir,
          settings = {
            java = {
              eclipse = { downloadSources = true },
              configuration = { updateBuildConfiguration = 'interactive' },
              maven = { downloadSources = true },
              implementationsCodeLens = { enabled = true },
              referencesCodeLens = { enabled = true },
              references = { includeDecompiledSources = true },
              format = { enabled = true },
            },
            signatureHelp = { enabled = true },
            completion = {
              favoriteStaticMembers = {
                'org.hamcrest.MatcherAssert.assertThat',
                'org.hamcrest.Matchers.*',
                'org.hamcrest.CoreMatchers.*',
                'org.junit.jupiter.api.Assertions.*',
                'java.util.Objects.requireNonNull',
                'java.util.Objects.requireNonNullElse',
                'org.mockito.Mockito.*',
              },
              importOrder = { 'java', 'javax', 'com', 'org' },
            },
          },
          init_options = {
            bundles = {},
          },
        }

        -- Start or attach to JDTLS
        jdtls.start_or_attach(config)
      end,
      group = vim.api.nvim_create_augroup('jdtls_setup', { clear = true }),
    })
  end,

  -- stylua: ignore
  keymaps = {
    -- Java-specific LSP keymaps (only active for Java files)
    { map = '<leader>co',  cmd = function() require('jdtls').organize_imports() end,        desc = 'Organize Imports',     ft = 'java' },
    { map = '<leader>crv', cmd = function() require('jdtls').extract_variable() end,       desc = 'Extract Variable',     ft = 'java' },
    { map = '<leader>crc', cmd = function() require('jdtls').extract_constant() end,       desc = 'Extract Constant',     ft = 'java' },
    { map = '<leader>crm', cmd = function() require('jdtls').extract_method(true) end,     desc = 'Extract Method',       ft = 'java', mode = 'v' },
    { map = '<leader>df',  cmd = function() require('jdtls').test_class() end,             desc = 'Test Class',           ft = 'java' },
    { map = '<leader>dn',  cmd = function() require('jdtls').test_nearest_method() end,    desc = 'Test Nearest Method',  ft = 'java' },
  },
})
