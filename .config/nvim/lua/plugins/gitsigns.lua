local git_signs_opts = {
  current_line_blame = true,
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'right_align',
    delay = 500,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  numhl = true,
}

P:add('https://github.com/lewis6991/gitsigns.nvim', 'gitsigns', {
  opts = git_signs_opts,
})

-- stylua: ignore
K:map {
  { map = '[c',         cmd = ':<C-U>Gitsigns next_hunk<CR>',                        desc = 'Previous Git Hunk', },
  { map = ']c',         cmd = ':<C-U>Gitsigns prev_hunk<CR>',                        desc = 'Next Git Hunk', },
  { map = '<leader>gs', cmd = ':<C-U>Gitsigns select_hunk<CR>',                      desc = 'Toggle Git Signs', },
  { map = '<leader>gd', cmd = function() require('gitsigns').toggle_deleted() end,   desc = 'Toggle Git Deleted', },
  { map = '<leader>gw', cmd = function() require('gitsigns').toggle_word_diff() end, desc = 'Toggle Git Word Diff', },
}
