local M = { 'lewis6991/gitsigns.nvim' }

M.config = function()
  require('gitsigns').setup {
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
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'right_align', -- 'eol' | 'overlay' | 'right_align'
      delay = 500,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1,
    },

    on_attach = function(buffer)
      local git_signs = require 'gitsigns'

      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = buffer
        vim.keymap.set(mode, l, r, opts)
      end

      -- Navigation
      map('n', ']c', function()
        if vim.wo.diff then
          vim.cmd.normal { ']c', bang = true }
        else
          git_signs.nav_hunk 'next'
        end
      end, { desc = 'Navigate To Next Hunk' })

      map('n', '[c', function()
        if vim.wo.diff then
          vim.cmd.normal { '[c', bang = true }
        else
          git_signs.nav_hunk 'prev'
        end
      end, { desc = 'Navigate To Previous Hunk' })

      -- Actions
      map('n', '<leader>gs', git_signs.stage_hunk, { desc = 'Stage Hunk' })
      map('n', '<leader>gr', git_signs.reset_hunk, { desc = 'Reset Hunk' })

      map('v', '<leader>gs', function()
        git_signs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Stage Hunk' })

      map('v', '<leader>gr', function()
        git_signs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
      end, { desc = 'Reset Hunk' })

      map('n', '<leader>gS', git_signs.stage_buffer, { desc = 'Stage Buffer' })
      map('n', '<leader>gR', git_signs.reset_buffer, { desc = 'Reset Buffer' })
      map('n', '<leader>gp', git_signs.preview_hunk, { desc = 'Preview Hunk' })
      map('n', '<leader>gi', git_signs.preview_hunk_inline, { desc = 'Preview Hunk Inline' })

      -- map('n', '<leader>hb', function()
      --   gitsigns.blame_line { full = true }
      -- end, { desc = 'Blame Line' })

      map('n', '<leader>gd', git_signs.diffthis, { desc = 'Diff This File' })
      map('n', '<leader>gD', function()
        git_signs.diffthis '~'
      end, { desc = 'Diff This File (cached)' })
      map('n', '<leader>gQ', function()
        git_signs.setqflist 'all'
      end, { desc = 'Set QuickFix List To All Hunks' })
      map('n', '<leader>gq', git_signs.setqflist, { desc = 'Set QuickFix List To Current Hunks' })

      -- Toggles
      map('n', '<leader>tb', git_signs.toggle_current_line_blame, { desc = 'Toggle Current Line Blame' })
      map('n', '<leader>td', git_signs.toggle_deleted, { desc = 'Toggle Deleted' })
      map('n', '<leader>tw', git_signs.toggle_word_diff, { desc = 'Toggle Word Diff' })

      -- Text object
      map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
    end,
  }
end

return M
