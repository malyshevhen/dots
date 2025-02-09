local M = { "stevearc/conform.nvim" }

-- event = 'BufWritePre', -- uncomment for format on save
M.opts = require "configs.conform"

return M
