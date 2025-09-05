return Plug.new('https://github.com/rmagatti/auto-session', 'auto-session', {
  opts = {
    suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '/tmp', '/private/tmp' },
    auto_restore = false,
    auto_restore_last_session = false,
    auto_save = true,
    auto_create = true,
    allowed_dirs = nil,
    auto_restore_lazy_delay_enabled = true,
    session_lens = {
      load_on_setup = true,
      theme_conf = { border = true },
      previewer = false,
    },
    log_level = vim.log.levels.ERROR,
    bypass_save_filetypes = { 'alpha', 'dashboard' },
    close_unsupported_windows = true,
    args_allow_single_directory = true,
    args_allow_files_auto_save = false,
    continue_restore_on_error = true,
    cwd_change_handling = {
      restore_upcoming_session = true,
      pre_cwd_changed_hook = nil,
      post_cwd_changed_hook = nil,
    },
    pre_save_cmds = {
      function()
        -- Close any floating windows before saving session
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if config.relative ~= '' then
            vim.api.nvim_win_close(win, false)
          end
        end
      end,
    },
    post_restore_cmds = {
      function()
        -- Refresh file tree or other plugins after session restore
        if vim.g.loaded_netrw == 1 then
          vim.cmd 'silent! Lexplore | silent! Lexplore'
        end
      end,
    },
  },

  config = function(opts)
    require('auto-session').setup(opts)

    -- Optional: Set up session lens integration
    local ok, session_lens = pcall(require, 'auto-session.session-lens')
    if ok then
      vim.keymap.set('n', '<C-s>', session_lens.search_session, {
        noremap = true,
        desc = 'Search sessions',
      })
    end
  end,

  -- stylua: ignore
  keymaps = {
    { map = '<leader>wr', cmd = '<cmd>Autosession search<CR>',    desc = 'Session search' },
    { map = '<leader>ws', cmd = '<cmd>SessionSave<CR>',           desc = 'Save session', },
    { map = '<leader>wa', cmd = '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave', },
    { map = '<leader>wd', cmd = '<cmd>SessionDelete<CR>',         desc = 'Delete session', },
    { map = '<leader>wD', cmd = '<cmd>SessionPurgeOrphaned<CR>',  desc = 'Delete orphaned sessions', },
    { map = '<leader>wl', cmd = '<cmd>SessionRestore<CR>',        desc = 'Load/Restore session', },
    {
      map = '<leader>wq',
      cmd = function()
        vim.cmd 'SessionSave'
        vim.cmd 'qa'
      end,
      desc = 'Save session and quit',
    },
  },
})
