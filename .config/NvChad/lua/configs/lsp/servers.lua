local M = {
  html = {},
  cssls = {},
  dockerls = {},
  marksman = {},
  jsonls = {},
}

local util = require "lspconfig.util"

-- AnsibleLS
M["ansiblels"] = {
  filetypes = { "yaml.ansible" },
}

-- Gopls
M["gopls"] = {
  cmd = { "gopls" },
  filetypes = { "go", "gomod", "gowork", "gotmpl" },
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
      directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
      semanticTokens = true,
    },
  },
}

-- Zig
M["zls"] = {
  filetypes = { "zig" },
  root_dir = util.root_pattern "build.zig",
}

-- Cypher LS
M["cypher_ls"] = {
  cmd = { "cypher-language-server", "--stdio" },
  filetypes = { "cypher" },
}

-- Cucumber LS
M["cucumber_language_server"] = {
  filetypes = { "cucumber", "feature" },
  root_dir = function(fname)
    return vim.fs.dirname(vim.fs.find("build.gradle", { path = fname, upward = true })[1])
  end,
  settings = {
    features = { "**/src/**/*.feature", "**/resources/**/*.feature" },
    glue = { "**/src/**/*.java", "**/src/**/*.kt", "**/test/**/*.kt", "**/steps/**/*.kt" },
  },
}

-- Ltex
local path = vim.fn.stdpath "config" .. "/spell/en.utf-8.add"
local words = {}

for word in io.open(path, "r"):lines() do
  table.insert(words, word)
end

M["ltex"] = {
  settings = {
    ltex = {
      disabledRules = {
        ["en-US"] = { "PROFANITY" },
        ["en-GB"] = { "PROFANITY" },
      },
      dictionary = {
        ["en-US"] = words,
        ["en-GB"] = words,
      },
    },
  },
}

-- YAML LS
M["yamlls"] = {
  filetypes = { "yaml", "yml" },
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
}

-- Docker-Compose LS
M["docker_compose_language_service"] = {
  filetypes = { "yaml.docker-compose" },
  root_dir = util.root_pattern("docker-compose.yaml", "docker-compose.yml", "compose.yaml", "compose.yml"),
}

return M
