return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = function() vim.fn["mkdp#util#install"]() end,
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  ft = { 'markdown' },
  keys = {
    { '<leader>rm', '<cmd>MarkdownPreview<cr>', desc = 'Toggle Markdown Preview' },
    { '<leader>rs', '<cmd>MarkdownPreviewStop<cr>', desc = 'Stop Markdown Preview' },
  },
}
