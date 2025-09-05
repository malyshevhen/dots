local Plug = require('types').Plug

return Plug.new('https://github.com/lewis6991/gitsigns.nvim', 'gitsigns', {
  opts = {
    signs = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged = {
      add = { text = '┃' },
      change = { text = '┃' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
      untracked = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align',
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },
    on_attach = function(bufnr)
      local function map(mode, lhs, rhs, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, lhs, rhs, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          require('gitsigns').nav_hunk 'next'
        end
      end, { desc = 'Next git hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          require('gitsigns').nav_hunk 'prev'
        end
      end, { desc = 'Previous git hunk' })

      -- Actions
      map('n', '<leader>hs', require('gitsigns').stage_hunk, { desc = 'Stage hunk' })
      map('n', '<leader>hr', require('gitsigns').reset_hunk, { desc = 'Reset hunk' })
      map('v', '<leader>hs', function()
        require('gitsigns').stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage hunk' })
      map('v', '<leader>hr', function()
        require('gitsigns').reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset hunk' })

      map('n', '<leader>hS', require('gitsigns').stage_buffer, { desc = 'Stage buffer' })
      map('n', '<leader>hu', require('gitsigns').undo_stage_hunk, { desc = 'Undo stage hunk' })
      map('n', '<leader>hR', require('gitsigns').reset_buffer, { desc = 'Reset buffer' })
      map('n', '<leader>hp', require('gitsigns').preview_hunk, { desc = 'Preview hunk' })
      map('n', '<leader>hb', function()
        require('gitsigns').blame_line { full = true }
      end, { desc = 'Blame line' })
      map('n', '<leader>hd', require('gitsigns').diffthis, { desc = 'Diff this' })
      map('n', '<leader>hD', function()
        require('gitsigns').diffthis '~'
      end, { desc = 'Diff this ~' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end,
  },
  keymaps = {
    {
      map = '<leader>gtb',
      cmd = function()
        require('gitsigns').toggle_current_line_blame()
      end,
      desc = 'Toggle Git Blame',
    },
    {
      map = '<leader>gd',
      cmd = function()
        require('gitsigns').toggle_deleted()
      end,
      desc = 'Toggle Git Deleted',
    },
    {
      map = '<leader>gw',
      cmd = function()
        require('gitsigns').toggle_word_diff()
      end,
      desc = 'Toggle Git Word Diff',
    },
    {
      map = '<leader>gs',
      cmd = function()
        require('gitsigns').toggle_signs()
      end,
      desc = 'Toggle Git Signs',
    },
    {
      map = '<leader>gn',
      cmd = function()
        require('gitsigns').toggle_numhl()
      end,
      desc = 'Toggle Git Number Highlight',
    },
  },
})
