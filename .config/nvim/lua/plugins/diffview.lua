local git_diff_opts = {
  hooks = {
    diff_buf_read = function(bufnr)
      -- Change local options in diff buffers
      vim.opt_local.wrap = false
      vim.opt_local.list = false
      vim.opt_local.colorcolumn = { 80 }
    end,
    view_opened = function(view)
      -- Highlight 'DiffviewFilePanelTitle' with 'Directory' group
      vim.cmd 'highlight! link DiffviewFilePanelTitle Directory'
    end,
  },
}

P:add('https://github.com/sindrets/diffview.nvim', 'diffview', {
  opts = git_diff_opts,
})

-- stylua: ignore
K:map {
  { map = '<leader>gD', cmd = '<cmd>DiffviewOpen<cr>',          desc = 'Open Git Diff View', },
  { map = '<leader>gC', cmd = '<cmd>DiffviewClose<cr>',         desc = 'Close Git Diff View', },
  { map = '<leader>gH', cmd = '<cmd>DiffviewFileHistory<cr>',   desc = 'Git File History', },
  { map = '<leader>gh', cmd = '<cmd>DiffviewFileHistory %<cr>', desc = 'Git File History (current file)', },
  { map = '<leader>gR', cmd = '<cmd>DiffviewRefresh<cr>',       desc = 'Refresh Diff View', },
  { map = '<leader>gF', cmd = '<cmd>DiffviewToggleFiles<cr>',   desc = 'Toggle Files Panel', },
  { map = '<leader>gf', cmd = '<cmd>DiffviewFocusFiles<cr>',    desc = 'Focus Files Panel', },
}
