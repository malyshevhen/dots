local M = { 'saghen/blink.compat' }

-- use the latest release, via version = '*', if you also use the latest release for blink.cmp
M.version = '*'
-- lazy.nvim will automatically load the plugin when it's required by blink.cmp
M.lazy = true
-- make sure to set opts so that lazy.nvim calls blink.compat's setup
M.opts = {}

return M
