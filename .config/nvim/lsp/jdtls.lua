---@brief
---
--- https://projects.eclipse.org/projects/eclipse.jdt.ls
---
--- Language server for Java.
---
--- IMPORTANT: If you want all the features jdtls has to offer, [nvim-jdtls](https://github.com/mfussenegger/nvim-jdtls)
--- is highly recommended. If all you need is diagnostics, completion, imports, gotos and formatting and some code actions
--- you can keep reading here.
---
--- For manual installation you can download precompiled binaries from the
--- [official downloads site](http://download.eclipse.org/jdtls/snapshots/?d)
--- and ensure that the `PATH` variable contains the `bin` directory of the extracted archive.
---
--- ```lua
---   -- init.lua
---   vim.lsp.enable('jdtls')
--- ```
---
--- You can also pass extra custom jvm arguments with the JDTLS_JVM_ARGS environment variable as a space separated list of arguments,
--- that will be converted to multiple --jvm-arg=<param> args when passed to the jdtls script. This will allow for example tweaking
--- the jvm arguments or integration with external tools like lombok:
---
--- ```sh
--- export JDTLS_JVM_ARGS="-javaagent:$HOME/.local/share/java/lombok.jar"
--- ```
---
--- For automatic installation you can use the following unofficial installers/launchers under your own risk:
---   - [jdtls-launcher](https://github.com/eruizc-dev/jdtls-launcher) (Includes lombok support by default)
---     ```lua
---       -- init.lua
---       vim.lsp.config('jdtls', { cmd = { 'jdtls' } })
---     ```

local handlers = require 'vim.lsp.handlers'

local env = {
  HOME = vim.uv.os_homedir(),
  XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
  JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
  LOMBOK_JAR = vim.fn.expand '$HOME/.m2/repository/org/projectlombok/lombok/1.18.30/lombok-1.18.30.jar',
}

local function get_cache_dir()
  return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or env.HOME .. '/.cache'
end

local function get_jdtls_cache_dir()
  return get_cache_dir() .. '/jdtls'
end

local function get_jdtls_config_dir()
  return get_jdtls_cache_dir() .. '/config'
end

local function get_jdtls_workspace_dir()
  return get_jdtls_cache_dir() .. '/workspace'
end

-- TextDocument version is reported as 0, override with nil so that
-- the client doesn't think the document is newer and refuses to update
-- See: https://github.com/eclipse/eclipse.jdt.ls/issues/1695
local function fix_zero_version(workspace_edit)
  if workspace_edit and workspace_edit.documentChanges then
    for _, change in pairs(workspace_edit.documentChanges) do
      local text_document = change.textDocument
      if text_document and text_document.version and text_document.version == 0 then
        text_document.version = nil
      end
    end
  end
  return workspace_edit
end

local function on_textdocument_codeaction(err, actions, ctx)
  for _, action in ipairs(actions) do
    -- TODO: (steelsojka) Handle more than one edit?
    if action.command == 'java.apply.workspaceEdit' then -- 'action' is Command in java format
      action.edit = fix_zero_version(action.edit or action.arguments[1])
    elseif type(action.command) == 'table' and action.command.command == 'java.apply.workspaceEdit' then -- 'action' is CodeAction in java format
      action.edit = fix_zero_version(action.edit or action.command.arguments[1])
    end
  end

  handlers[ctx.method](err, actions, ctx)
end

local function on_textdocument_rename(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

local function on_workspace_applyedit(err, workspace_edit, ctx)
  handlers[ctx.method](err, fix_zero_version(workspace_edit), ctx)
end

-- Non-standard notification that can be used to display progress
local function on_language_status(_, result)
  local command = vim.api.nvim_command
  command 'echohl ModeMsg'
  command(string.format('echo "%s"', result.message))
  command 'echohl None'
end

local cmd = {
  'jdtls',
  '-configuration',
  get_jdtls_config_dir(),
  '-data',
  get_jdtls_workspace_dir(),
  '--jvm-arg=-Declipse.application=org.eclipse.jdt.ls.core.id1',
  '--jvm-arg=-Dosgi.bundles.defaultStartLevel=4',
  '--jvm-arg=-Declipse.product=org.eclipse.jdt.ls.core.product',
  '--jvm-arg=-Dlog.protocol=true',
  '--jvm-arg=-Dlog.level=ALL',
  '--jvm-arg=-Xms1g',
  ('--jvm-arg=-javaagent:%s'):format(env.LOMBOK_JAR),
  ('--jvm-arg=-Xbootclasspath/a:%s'):format(env.LOMBOK_JAR),
}

-- Uncomment to debug the command
-- print(vim.inspect(cmd))

---@type vim.lsp.Config
return {
  cmd = cmd,
  filetypes = { 'java' },
  root_markers = {
    -- Multi-module projects
    '.git',
    'build.gradle',
    'build.gradle.kts',
    -- Single-module projects
    'build.xml', -- Ant
    'pom.xml', -- Maven
    'settings.gradle', -- Gradle
    'settings.gradle.kts', -- Gradle
  },
  init_options = {
    workspace = get_jdtls_workspace_dir(),
    jvm_args = {},
    os_config = nil,
  },
  settings = {
    java = {
      format = {
        enabled = true,
        settings = {
          url = 'https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xm',
          profile = 'GoogleStyle',
        },
      },
    },
  },
  handlers = {
    -- Due to an invalid protocol implementation in the jdtls we have to conform these to be spec compliant.
    -- https://github.com/eclipse/eclipse.jdt.ls/issues/376
    ['textDocument/codeAction'] = on_textdocument_codeaction,
    ['textDocument/rename'] = on_textdocument_rename,
    ['workspace/applyEdit'] = on_workspace_applyedit,
    ['language/status'] = vim.schedule_wrap(on_language_status),
  },
}
