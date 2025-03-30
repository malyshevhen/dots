local M = { 'iamcco/markdown-preview.nvim' }

M.ft = { 'markdown' }

M.build = function()
  vim.fn['mkdp#util#install']()
end

-- stylua: ignore
M.keys = {
        { '<leader>rm', '<cmd>MarkdownPreview<cr>',     desc = 'Toggle Markdown Preview' },
        { '<leader>rs', '<cmd>MarkdownPreviewStop<cr>', desc = 'Stop Markdown Preview' },
}

M.cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' }

M.init = function()
  vim.g.mkdp_filetypes = { 'markdown' }
end

return M
