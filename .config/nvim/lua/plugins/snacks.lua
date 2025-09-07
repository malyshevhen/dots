P:add('https://github.com/folke/snacks.nvim', 'snacks', {
  opts = {
    quickfile = { enabled = true },
    picker = { enabled = true },
  },

  config = function()
    vim.api.nvim_create_autocmd('User', {
      pattern = 'VeryLazy',
      callback = function()
        -- Setup debugging globals
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end

        vim.print = _G.dd

        -- Toggle mappings
        local toggles = {
          { 'spell', '<leader>us', 'Spelling' },
          { 'wrap', '<leader>uw', 'Wrap' },
          { 'relativenumber', '<leader>uL', 'Relative Number' },
        }

        for _, toggle in ipairs(toggles) do
          Snacks.toggle.option(toggle[1], { name = toggle[3] }):map(toggle[2])
        end

        Snacks.toggle.diagnostics():map '<leader>ud'
        Snacks.toggle.line_number():map '<leader>ul'
        Snacks.toggle
          .option('conceallevel', {
            off = 0,
            on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2,
          })
          :map '<leader>uc'
        Snacks.toggle.treesitter():map '<leader>uT'
        Snacks.toggle
          .option('background', {
            off = 'light',
            on = 'dark',
            name = 'Dark Background',
          })
          :map '<leader>ub'
        Snacks.toggle.inlay_hints():map '<leader>uh'
        Snacks.toggle.indent():map '<leader>ug'
        Snacks.toggle.dim():map '<leader>uD'
      end,
    })
  end,
})

-- stylua: ignore
K:map {
  -- Core functionality
  { map = '<leader>z',       cmd = function() Snacks.zen() end,                                          desc = 'Toggle Zen Mode', },
  { map = '<leader>Z',       cmd = function() Snacks.zen.zoom() end,                                     desc = 'Toggle Zoom', },
  { map = '<leader>.',       cmd = function() Snacks.scratch() end,                                      desc = 'Toggle Scratch Buffer', },
  { map = '<leader>S',       cmd = function() Snacks.scratch.select() end,                               desc = 'Select Scratch Buffer', },
  { map = '<leader>bd',      cmd = function() Snacks.bufdelete() end,                                    desc = 'Delete Buffer', },
  { map = '<leader>cR',      cmd = function() Snacks.rename.rename_file() end,                           desc = 'Rename File', },

  -- Navigation and pickers
  { map = '<leader><space>', cmd = function() Snacks.picker.smart() end,                                 desc = 'Smart Find Files', },
  { map = '<leader>,',       cmd = function() Snacks.picker.buffers() end,                               desc = 'Buffers', },
  { map = '<leader>/',       cmd = function() Snacks.picker.grep() end,                                  desc = 'Grep', },
  { map = '<leader>:',       cmd = function() Snacks.picker.command_history() end,                       desc = 'Command History', },
  { map = '\\',              cmd = function() Snacks.explorer() end,                                     desc = 'File Explorer', },
  { map = '<leader>e',       cmd = function() Snacks.explorer.reveal() end,                              desc = 'File Explorer', },

  -- File operations
  { map = '<leader>fb',      cmd = function() Snacks.picker.buffers() end,                               desc = 'Buffers', },
  { map = '<leader>fc',      cmd = function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File', },
  { map = '<leader>ff',      cmd = function() Snacks.picker.files() end,                                 desc = 'Find Files', },
  { map = '<leader>fg',      cmd = function() Snacks.picker.git_files() end,                             desc = 'Find Git Files', },
  { map = '<leader>fr',      cmd = function() Snacks.picker.recent() end,                                desc = 'Recent', },

  -- Git operations
  { map = '<leader>gB',      cmd = function() Snacks.gitbrowse() end,                                    desc = 'Git Browse',                mode = { 'n', 'v' }, },
  { map = '<leader>gb',      cmd = function() Snacks.git.blame_line() end,                               desc = 'Git Blame Line', },
  { map = '<leader>gg',      cmd = function() Snacks.lazygit() end,                                      desc = 'Lazygit', },
  { map = '<leader>gl',      cmd = function() Snacks.lazygit.log() end,                                  desc = 'Lazygit Log (cwd)', },

  -- Search operations
  { map = '<leader>sg',      cmd = function() Snacks.picker.grep() end,                                  desc = 'Grep', },
  { map = '<leader>sw',      cmd = function() Snacks.picker.grep_word() end,                             desc = 'Visual selection or word',  mode = { 'n', 'x' }, },
  { map = '<leader>sb',      cmd = function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines', },
  { map = '<leader>sd',      cmd = function() Snacks.picker.diagnostics() end,                           desc = 'Diagnostics', },
  { map = '<leader>sh',      cmd = function() Snacks.picker.help() end,                                  desc = 'Help Pages', },
  { map = '<leader>sk',      cmd = function() Snacks.picker.keymaps() end,                               desc = 'Keymaps', },

  -- LSP operations
  { map = 'gd',              cmd = function() Snacks.picker.lsp_definitions() end,                       desc = 'Goto Definition', },
  { map = 'gD',              cmd = function() Snacks.picker.lsp_declarations() end,                      desc = 'Goto Declaration', },
  { map = 'gR',              cmd = function() Snacks.picker.lsp_references() end,                        desc = 'References', },
  { map = 'gI',              cmd = function() Snacks.picker.lsp_implementations() end,                   desc = 'Goto Implementation', },
  { map = 'gy',              cmd = function() Snacks.picker.lsp_type_definitions() end,                  desc = 'Goto T[y]pe Definition', },
  { map = '<leader>ss',      cmd = function() Snacks.picker.lsp_symbols() end,                           desc = 'LSP Symbols', },

  -- Notifications
  { map = '<leader>n',       cmd = function() Snacks.notifier.show_history() end,                        desc = 'Notification History', },
  { map = '<leader>un',      cmd = function() Snacks.notifier.hide() end,                                desc = 'Dismiss All Notifications', },
}
