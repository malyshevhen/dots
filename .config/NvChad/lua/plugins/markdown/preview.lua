local M = { "iamcco/markdown-preview.nvim" }

M.cmd = {
  "MarkdownPreviewToggle",
  "MarkdownPreview",
  "MarkdownPreviewStop",
}

M.build = "cd app && yarn install"

M.init = function()
  vim.g.mkdp_filetypes = { "markdown" }
end

M.ft = { "markdown" }

M.keys = {
  { "<leader>rm", "<cmd>MarkdownPreview<cr>", desc = "Toggle Markdown Preview" },
  { "<leader>rs", "<cmd>MarkdownPreviewStop<cr>", desc = "Stop Markdown Preview" },
}

return M
