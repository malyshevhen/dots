P:add('https://github.com/sindrets/diffview.nvim', 'diffview', {
  opts = {
    diff_binaries = false,
    enhanced_diff_hl = false,
    git_cmd = { 'git' },
    hg_cmd = { 'hg' },
    use_icons = true,
    show_help_hints = true,
    watch_index = true,
    icons = {
      folder_closed = '',
      folder_open = '',
    },
    signs = {
      fold_closed = '',
      fold_open = '',
      done = '✓',
    },
    view = {
      default = {
        layout = 'diff2_horizontal',
        disable_diagnostics = true,
        winbar_info = false,
      },
      merge_tool = {
        layout = 'diff3_horizontal',
        disable_diagnostics = true,
        winbar_info = true,
      },
      file_history = {
        layout = 'diff2_horizontal',
        disable_diagnostics = true,
        winbar_info = false,
      },
    },
    file_panel = {
      listing_style = 'tree',
      tree_options = {
        flatten_dirs = true,
        folder_statuses = 'only_folded',
      },
      win_config = {
        position = 'left',
        width = 35,
        win_opts = {},
      },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = 'combined',
          },
          multi_file = {
            diff_merges = 'first-parent',
          },
        },
        hg = {
          single_file = {},
          multi_file = {},
        },
      },
      win_config = {
        position = 'bottom',
        height = 16,
        win_opts = {},
      },
    },
    commit_log_panel = {
      win_config = {
        win_opts = {},
      },
    },
    default_args = {
      DiffviewOpen = {},
      DiffviewFileHistory = {},
    },
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
  },
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
