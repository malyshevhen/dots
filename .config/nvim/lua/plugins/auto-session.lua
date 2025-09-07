local auto_session_opts = {
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/', '/tmp', '/private/tmp' },
  auto_restore = false,
  auto_restore_last_session = false,
  bypass_save_filetypes = { 'alpha', 'dashboard', 'snacks_dashboard' },
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
}

P:add('https://github.com/rmagatti/auto-session', 'auto-session', {
  opts = auto_session_opts,

  config = function(opts)
    require('auto-session').setup(opts)
  end,
})

-- stylua: ignore
K:map {
  { map = '<leader>wr', cmd = '<cmd>AutoSession search<CR>',        desc = 'Session search' },
  { map = '<leader>ws', cmd = '<cmd>AutoSession save<CR>',          desc = 'Save session', },
  { map = '<leader>wa', cmd = '<cmd>AutoSession toggle<CR>',        desc = 'Toggle autosave', },
  { map = '<leader>wd', cmd = '<cmd>AutoSession delete<CR>',        desc = 'Delete session', },
  { map = '<leader>wD', cmd = '<cmd>AutoSession purgeOrphaned<CR>', desc = 'Delete orphaned sessions', },
  { map = '<leader>wl', cmd = '<cmd>AutoSession restore<CR>',       desc = 'Load/Restore session', },
}
