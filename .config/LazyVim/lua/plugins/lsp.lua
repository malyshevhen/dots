return {
  "neovim/nvim-lspconfig",
  ---@class PluginLspOpts
  opts = {
    ---@type lspconfig.options
    servers = {
      cucumber_language_server = {
        filetypes = { "cucumber", "feature" },
        root_dir = function(fname)
          return vim.fs.dirname(vim.fs.find("build.gradle", { path = fname, upward = true })[1])
        end,
        settings = {
          features = { "**/src/**/*.feature", "**/resources/**/*.feature" },
          glue = { "**/src/**/*.java", "**/src/**/*.kt", "**/test/**/*.kt", "**/steps/**/*.kt" },
        },
      },
    },
  },
}
