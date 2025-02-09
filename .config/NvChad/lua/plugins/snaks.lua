local M = { "folke/snacks.nvim" }

M.priority = 1000
M.lazy = false

---@type snacks.Config
M.opts = {
  indent = { enabled = true },
  input = { enabled = true },
  notifier = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
}

return M
