local readAll = function(file)
  local f = assert(io.open(file, 'rb'))
  local content = f:read '*all'
  f:close()
  return content or ''
end

local M = { 'folke/snacks.nvim' }

M.priority = 1000

M.lazy = false

---@type snacks.input.Config
local input = {
  enabled = true,
  icon = ' ',
  icon_hl = 'SnacksInputIcon',
  icon_pos = 'left',
  prompt_pos = 'title',
  win = { style = 'input' },
  expand = true,
}

---@type snacks.dashboard.Config
local dashboard = {
  enabled = true,
  preset = {
    -- stylua: ignore
    header = readAll(vim.fn.stdpath("config") .. "/dash-2"),
  },
}

---@type snacks.Config
M.opts = {
  input = input,
  notifier = { enabled = true, timeout = 3000 },
  quickfile = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
  picker = { enabled = true },
  dashboard = dashboard,
  indent = { enabled = true },
}

M.opts.styles = {
  notification = {
    wo = { wrap = true }, -- Wrap notifications
  },
  input = {
    {
      backdrop = true,
      position = 'float',
      border = 'rounded',
      title_pos = 'center',
      height = 1,
      width = 60,
      relative = 'editor',
      noautocmd = true,
      row = 2,
      -- relative = "cursor",
      -- row = -3,
      -- col = 0,
      wo = {
        winhighlight = 'NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle',
        cursorline = true,
      },
      bo = {
        filetype = 'snacks_input',
        buftype = 'prompt',
      },
      --- buffer local variables
      b = {
        completion = true, -- disable blink completions in input
      },
      keys = {
        n_esc = { '<esc>', { 'cmp_close', 'cancel' }, mode = 'n', expr = true },
        i_esc = { '<esc>', { 'cmp_close', 'stopinsert' }, mode = 'i', expr = true },
        i_cr = { '<cr>', { 'cmp_accept', 'confirm' }, mode = 'i', expr = true },
        i_tab = { '<tab>', { 'cmp_select_next', 'cmp' }, mode = 'i', expr = true },
        q = 'cancel',
      },
    },
  },
}

M.init = function()
  vim.api.nvim_create_autocmd('User', {
    pattern = 'VeryLazy',
    callback = function()
      -- Setup some globals for debugging (lazy-loaded)
      _G.dd = function(...)
        Snacks.debug.inspect(...)
      end
      _G.bt = function()
        Snacks.debug.backtrace()
      end
      vim.print = _G.dd -- Override print to use snacks for `:=` command

      -- Create some toggle mappings
      Snacks.toggle.option('spell', { name = 'Spelling' }):map '<leader>us'
      Snacks.toggle.option('wrap', { name = 'Wrap' }):map '<leader>uw'
      Snacks.toggle.option('relativenumber', { name = 'Relative Number' }):map '<leader>uL'
      Snacks.toggle.diagnostics():map '<leader>ud'
      Snacks.toggle.line_number():map '<leader>ul'
      Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map '<leader>uc'
      Snacks.toggle.treesitter():map '<leader>uT'
      Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background' }):map '<leader>ub'
      Snacks.toggle.inlay_hints():map '<leader>uh'
      Snacks.toggle.indent():map '<leader>ug'
      Snacks.toggle.dim():map '<leader>uD'
    end,
  })
end

-- stylua: ignore
M.keys = {
  { '<leader>z',       function() Snacks.zen() end,                                          desc = 'Toggle Zen Mode' },
  { '<leader>Z',       function() Snacks.zen.zoom() end,                                     desc = 'Toggle Zoom' },
  { '<leader>.',       function() Snacks.scratch() end,                                      desc = 'Toggle Scratch Buffer' },
  { '<leader>S',       function() Snacks.scratch.select() end,                               desc = 'Select Scratch Buffer' },
  { '<leader>n',       function() Snacks.notifier.show_history() end,                        desc = 'Notification History' },
  { '<leader>bd',      function() Snacks.bufdelete() end,                                    desc = 'Delete Buffer' },
  { '<leader>cR',      function() Snacks.rename.rename_file() end,                           desc = 'Rename File' },
  { '<leader>gB',      function() Snacks.gitbrowse() end,                                    desc = 'Git Browse',                  mode = { 'n', 'v' } },
  { '<leader>gb',      function() Snacks.git.blame_line() end,                               desc = 'Git Blame Line' },
  { '<leader>gf',      function() Snacks.lazygit.log_file() end,                             desc = 'Lazygit Current File History' },
  { '<leader>gg',      function() Snacks.lazygit() end,                                      desc = 'Lazygit' },
  { '<leader>gl',      function() Snacks.lazygit.log() end,                                  desc = 'Lazygit Log (cwd)' },
  { '<leader>un',      function() Snacks.notifier.hide() end,                                desc = 'Dismiss All Notifications' },
  { '<c-/>',           function() Snacks.terminal() end,                                     desc = 'Toggle Terminal' },
  { '<c-_>',           function() Snacks.terminal() end,                                     desc = 'which_key_ignore' },
  { ']]',              function() Snacks.words.jump(vim.v.count1) end,                       desc = 'Next Reference',              mode = { 'n', 't' } },
  { '[[',              function() Snacks.words.jump(-vim.v.count1) end,                      desc = 'Prev Reference',              mode = { 'n', 't' } },

  -- Top Pickers & Explorer
  { '<leader><space>', function() Snacks.picker.smart() end,                                 desc = 'Smart Find Files' },
  { '<leader>,',       function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
  { '<leader>/',       function() Snacks.picker.grep() end,                                  desc = 'Grep' },
  { '<leader>:',       function() Snacks.picker.command_history() end,                       desc = 'Command History' },
  { '<leader>n',       function() Snacks.picker.notifications() end,                         desc = 'Notification History' },
  { '\\',              function() Snacks.explorer() end,                                     desc = 'File Explorer' },
  { '<leader>e',       function() Snacks.explorer.reveal() end,                              desc = 'File Explorer' },

  -- find
  { '<leader>fb',      function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
  { '<leader>fc',      function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
  { '<leader>ff',      function() Snacks.picker.files() end,                                 desc = 'Find Files' },
  { '<leader>fg',      function() Snacks.picker.git_files() end,                             desc = 'Find Git Files' },
  { '<leader>fp',      function() Snacks.picker.projects() end,                              desc = 'Projects' },
  { '<leader>fr',      function() Snacks.picker.recent() end,                                desc = 'Recent' },

  -- git
  { '<leader>gb',      function() Snacks.picker.git_branches() end,                          desc = 'Git Branches' },
  { '<leader>gl',      function() Snacks.picker.git_log() end,                               desc = 'Git Log' },
  { '<leader>gL',      function() Snacks.picker.git_log_line() end,                          desc = 'Git Log Line' },
  { '<leader>gs',      function() Snacks.picker.git_status() end,                            desc = 'Git Status' },
  { '<leader>gS',      function() Snacks.picker.git_stash() end,                             desc = 'Git Stash' },
  { '<leader>gd',      function() Snacks.picker.git_diff() end,                              desc = 'Git Diff (Hunks)' },
  { '<leader>gf',      function() Snacks.picker.git_log_file() end,                          desc = 'Git Log File' },

  -- Grep
  { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
  { '<leader>sB',      function() Snacks.picker.grep_buffers() end,                          desc = 'Grep Open Buffers' },
  { '<leader>sg',      function() Snacks.picker.grep() end,                                  desc = 'Grep' },
  { '<leader>sw',      function() Snacks.picker.grep_word() end,                             desc = 'Visual selection or word',    mode = { 'n', 'x' } },

  -- search
  { '<leader>s"',      function() Snacks.picker.registers() end,                             desc = 'Registers' },
  { '<leader>s/',      function() Snacks.picker.search_history() end,                        desc = 'Search History' },
  { '<leader>sa',      function() Snacks.picker.autocmds() end,                              desc = 'Autocmds' },
  { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
  { '<leader>sc',      function() Snacks.picker.command_history() end,                       desc = 'Command History' },
  { '<leader>sC',      function() Snacks.picker.commands() end,                              desc = 'Commands' },
  { '<leader>sd',      function() Snacks.picker.diagnostics() end,                           desc = 'Diagnostics' },
  { '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end,                    desc = 'Buffer Diagnostics' },
  { '<leader>sh',      function() Snacks.picker.help() end,                                  desc = 'Help Pages' },
  { '<leader>sH',      function() Snacks.picker.highlights() end,                            desc = 'Highlights' },
  { '<leader>si',      function() Snacks.picker.icons() end,                                 desc = 'Icons' },
  { '<leader>sj',      function() Snacks.picker.jumps() end,                                 desc = 'Jumps' },
  { '<leader>sk',      function() Snacks.picker.keymaps() end,                               desc = 'Keymaps' },
  { '<leader>sl',      function() Snacks.picker.loclist() end,                               desc = 'Location List' },
  { '<leader>sm',      function() Snacks.picker.marks() end,                                 desc = 'Marks' },
  { '<leader>sM',      function() Snacks.picker.man() end,                                   desc = 'Man Pages' },
  { '<leader>sp',      function() Snacks.picker.lazy() end,                                  desc = 'Search for Plugin Spec' },
  { '<leader>sq',      function() Snacks.picker.qflist() end,                                desc = 'Quickfix List' },
  { '<leader>sR',      function() Snacks.picker.resume() end,                                desc = 'Resume' },
  { '<leader>su',      function() Snacks.picker.undo() end,                                  desc = 'Undo History' },
  { '<leader>uC',      function() Snacks.picker.colorschemes() end,                          desc = 'Colorschemes' },

  -- LSP
  { 'gd',              function() Snacks.picker.lsp_definitions() end,                       desc = 'Goto Definition' },
  { 'gD',              function() Snacks.picker.lsp_declarations() end,                      desc = 'Goto Declaration' },
  { 'gR',              function() Snacks.picker.lsp_references() end,                        desc = 'References',                  nowait = true },
  { 'gI',              function() Snacks.picker.lsp_implementations() end,                   desc = 'Goto Implementation' },
  { 'gy',              function() Snacks.picker.lsp_type_definitions() end,                  desc = 'Goto T[y]pe Definition' },
  { '<leader>ss',      function() Snacks.picker.lsp_symbols() end,                           desc = 'LSP Symbols' },
  { '<leader>sS',      function() Snacks.picker.lsp_workspace_symbols() end,                 desc = 'LSP Workspace Symbols' },
}

return M
