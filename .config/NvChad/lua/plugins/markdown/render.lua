local M = { "MeanderingProgrammer/render-markdown.nvim" }

M.dependencies = {
  "nvim-treesitter/nvim-treesitter",
  "echasnovski/mini.nvim", -- if you use the mini.nvim suite
}

M.ft = { 'markdown' }

---@module 'render-markdown'
---@type render.md.UserConfig
M.opts = {}

return M
