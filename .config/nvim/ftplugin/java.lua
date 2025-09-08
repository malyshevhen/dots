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

-- Function to get Lombok jar path
local function get_lombok_jar()
  -- First try the specific version mentioned
  local specific_lombok =
    vim.fn.expand '$HOME/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar'
  if vim.fn.filereadable(specific_lombok) == 1 then
    return specific_lombok
  end

  -- Try to find any Lombok version in the repository
  local lombok_dir = vim.fn.expand '$HOME/.m2/repository/org/projectlombok/lombok'
  if vim.fn.isdirectory(lombok_dir) == 1 then
    local versions = vim.fn.glob(lombok_dir .. '/*/lombok-*.jar', false, true)

    -- Sort versions and take the latest one
    if #versions > 0 then
      table.sort(versions, function(a, b)
        -- Extract version numbers and compare
        local version_a = string.match(a, 'lombok%-([%d%.]+)%.jar')
        local version_b = string.match(b, 'lombok%-([%d%.]+)%.jar')
        if version_a and version_b then
          return version_a > version_b
        end
        return a > b
      end)
      return versions[1]
    end
  end

  -- Fallback: check common locations
  local fallback_paths = {
    vim.fn.expand '$HOME/.m2/repository/org/projectlombok/lombok/1.18.32/lombok-1.18.32.jar',
    vim.fn.expand '$HOME/.m2/repository/org/projectlombok/lombok/1.18.28/lombok-1.18.28.jar',
    vim.fn.expand '$HOME/.local/share/lombok/lombok.jar',
    '/opt/lombok/lombok.jar',
  }

  for _, path in ipairs(fallback_paths) do
    if vim.fn.filereadable(path) == 1 then
      return path
    end
  end

  return nil
end

-- Find root directory
local root_dir =
  require('jdtls.setup').find_root { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle' }

-- Determine the OS config directory
local os_config = get_os_config()

-- Use the jdtls command we installed
local cmd
if vim.fn.executable 'jdtls' == 1 then
  -- Ensure workspace directory exists
  local workspace = get_workspace_dir()
  vim.fn.mkdir(workspace, 'p')

  -- Build command with Lombok support if available
  cmd = { 'jdtls', '-data', workspace }

  -- Add Lombok javaagent if available
  local lombok_jar = get_lombok_jar()
  if lombok_jar then
    table.insert(cmd, '--jvm-arg=-javaagent:' .. lombok_jar)
    local version = string.match(lombok_jar, 'lombok%-([%d%.]+)%.jar') or 'unknown'
    vim.notify('Lombok integration enabled (version: ' .. version .. ')', vim.log.levels.INFO)
  else
    vim.notify(
      'Lombok jar not found. Install with: mvn dependency:get -Dartifact=org.projectlombok:lombok:1.18.30',
      vim.log.levels.WARN
    )
  end
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
      configuration = {
        updateBuildConfiguration = 'interactive',
        runtimes = {},
        -- Enable Lombok annotation processing
        workspaceFolder = get_workspace_dir(),
      },
      maven = { downloadSources = true },
      implementationsCodeLens = { enabled = true },
      referencesCodeLens = { enabled = true },
      references = { includeDecompiledSources = true },
      format = { enabled = true },
      -- Lombok-specific settings
      compile = {
        nullAnalysis = {
          mode = 'automatic',
        },
      },
      contentProvider = {
        preferred = 'fernflower',
      },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
      -- Enhanced import settings
      saveActions = {
        organizeImports = true,
      },
      autobuild = {
        enabled = true,
      },
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
        -- Add Lombok static imports
        'lombok.AccessLevel.*',
        'lombok.experimental.FieldDefaults.*',
      },
      importOrder = { 'java', 'javax', 'com', 'org' },
      -- Auto import settings
      maxConcurrentBuilds = 1,
      -- Enable additional text edits for imports
      resolveAdditionalTextEditsSupport = true,
      filteredTypes = {
        -- Hide Lombok generated classes from completion
        'com.sun.*',
        'sun.*',
        'jdk.internal.*',
        'io.micrometer.shaded.*',
      },
      -- Enable auto-imports on completion
      enabled = true,
      guessMethodArguments = true,
      includeDecompiledSources = true,
      postfix = {
        enabled = true,
      },
    },
  },
  init_options = {
    bundles = {},
  },
  -- Add completion handlers for automatic imports
  capabilities = vim.tbl_deep_extend('force', vim.lsp.protocol.make_client_capabilities(), {
    textDocument = {
      completion = {
        completionItem = {
          resolveSupport = {
            properties = { 'documentation', 'detail', 'additionalTextEdits' },
          },
        },
      },
    },
  }),
  handlers = {
    -- Handle completion resolve to add imports automatically
    ['completionItem/resolve'] = function(err, result, ctx, config)
      if result and result.additionalTextEdits then
        vim.lsp.util.apply_text_edits(result.additionalTextEdits, ctx.bufnr, 'utf-8')
      end
      return vim.lsp.handlers['completionItem/resolve'](err, result, ctx, config)
    end,
  },
}

-- Start or attach to JDTLS
jdtls.start_or_attach(config)

-- Set up completion with automatic imports for this buffer
vim.api.nvim_create_autocmd('LspAttach', {
  buffer = vim.api.nvim_get_current_buf(),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == 'jdtls' then
      -- Enable completion with resolve support
      if client.supports_method 'textDocument/completion' then
        vim.lsp.completion.enable(true, client.id, args.buf, {
          autotrigger = true,
          resolve = true, -- This enables automatic import resolution
        })
      end
    end
  end,
})


-- stylua: ignore
K:map {
  -- Java-specific LSP keymaps (only active for Java files)
  { map = '<leader>co',  cmd = function() require('jdtls').organize_imports() end,    desc = 'Organize Imports',    ft = 'java' },
  { map = '<leader>crv', cmd = function() require('jdtls').extract_variable() end,    desc = 'Extract Variable',    ft = 'java' },
  { map = '<leader>crc', cmd = function() require('jdtls').extract_constant() end,    desc = 'Extract Constant',    ft = 'java' },
  { map = '<leader>crm', cmd = function() require('jdtls').extract_method(true) end,  desc = 'Extract Method',      ft = 'java', mode = 'v' },
  { map = '<leader>df',  cmd = function() require('jdtls').test_class() end,          desc = 'Test Class',          ft = 'java' },
  { map = '<leader>dn',  cmd = function() require('jdtls').test_nearest_method() end, desc = 'Test Nearest Method', ft = 'java' },

  -- Lombok-specific keymaps
  { map = '<leader>cl',  cmd = '',                                                    desc = '+lombok',             ft = 'java' },
  {
    map = '<leader>cld',
    cmd = function()
      local current_file = vim.fn.expand('%:p')
      local cmd = 'java -jar ' ..
          vim.fn.expand('$HOME/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar') ..
          ' delombok ' .. current_file
      vim.fn.system(cmd)
      vim.notify('Delombok completed for ' .. vim.fn.expand('%:t'), vim.log.levels.INFO)
    end,
    desc = 'Delombok Current File',
    ft = 'java'
  },
  {
    map = '<leader>clr',
    cmd = function()
      vim.lsp.buf.code_action({
        filter = function(action)
          return string.match(action.title or '', 'lombok') or string.match(action.title or '', 'Lombok')
        end,
        apply = true,
      })
    end,
    desc = 'Lombok Refactor',
    ft = 'java'
  },
  {
    map = '<leader>clg',
    cmd = function()
      -- Generate getters/setters using LSP code actions
      vim.lsp.buf.code_action({
        filter = function(action)
          local title = action.title or ''
          return string.match(title, 'Generate getter') or
              string.match(title, 'Generate setter') or
              string.match(title, 'Generate constructor')
        end,
        apply = true,
      })
    end,
    desc = 'Generate Methods',
    ft = 'java'
  },

  -- Manual import organization fallback
  { map = '<leader>ci', cmd = function() require('jdtls').organize_imports() end, desc = 'Organize Imports (Manual)', ft = 'java' },
}
