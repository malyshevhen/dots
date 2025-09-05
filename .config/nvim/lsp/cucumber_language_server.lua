---@brief
---
--- https://cucumber.io
--- https://github.com/cucumber/common
--- https://www.npmjs.com/package/@cucumber/language-server
---
--- Language server for Cucumber.
---
--- `cucumber-language-server` can be installed via `npm`:
--- ```sh
--- npm install -g @cucumber/language-server
--- ```

---@type vim.lsp.Config
return {
  cmd = { 'cucumber-language-server', '--stdio' },
  filetypes = { 'cucumber' },
  -- root_markers = { '.git', 'pom.xml', 'build.gradle', '.build.gradle' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local path = vim.fs.dirname(fname)
    local match = vim.fs.find({ '.git', 'pom.xml', 'build.gradle' }, { upward = true, path = path })[1]
    on_dir(match and vim.fs.dirname(match) or nil)
  end,
  settings = {
    cucumber = {
      features = { '**/src/**/*.feature', '**/resources/**/*.feature' },
      glue = { '**/src/**/*.java', '**/src/**/*.kt', '**/test/**/*.kt', '**/steps/**/*.kt' },
    },
  },
}
