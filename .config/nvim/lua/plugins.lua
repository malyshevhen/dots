local Plug = require('types').Plug
local Keymap = require('types').Keymap

---@type Plug[]
local plugins = {

  Plug.new('https://github.com/goolord/alpha-nvim', 'alpha', {

    deps = {
      'https://github.com/nvim-tree/nvim-web-devicons',
    },

    config = function()
      require('alpha').setup(require('alpha.themes.dashboard').config)
    end,
  }),

  Plug.new('https://github.com/rmagatti/auto-session', 'auto-session', {

    opts = {
      suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
      auto_restore = false,
      auto_restore_last_session = false,
    },

    -- stylua: ignore
    keymaps = {
      { map = '<leader>wr', cmd = '<cmd>AutoSession search<CR>', desc = 'Session search' },
      { map = '<leader>ww', cmd = '<cmd>AutoSession save<CR>',   desc = 'Save session' },
      { map = '<leader>wa', cmd = '<cmd>AutoSession toggle<CR>', desc = 'Toggle autosave' },
    },
  }),

  Plug.new('https://github.com/windwp/nvim-autopairs', 'nvim-autopairs', { opts = { map_cr = true } }),

  Plug.new('https://github.com/stevearc/conform.nvim', 'conform', {
    opts = {
      formatters_by_ft = {
        lua = { 'stylua', lsp_format = 'first' },
        -- Conform will run multiple formatters sequentially
        rust = { 'rustfmt', lsp_format = 'fallback' },
        -- Conform will run the first available formatter
        javascript = { 'prettierd', 'prettier', stop_after_first = true },
        -- Conform will run multiple formatters sequentially
        go = { 'goimports', 'gofmt' },
        -- Java
        java = { 'google-java-format' },
        -- Bash
        sh = { 'shfmt' },
        -- SQL
        -- sql = { 'sleek' },
        -- Gleam
        gleam = { 'gleam format', lsp_format = 'fallback' },
        -- Elixir
        elixir = { 'mix format', lsp_format = 'fallback' },
        -- Python
        python = { 'ruff_format', 'ruff_fix', 'ruff_imports', lsp_format = 'fallback' },
        -- TOML
        toml = { 'taplo' },
      },
    },

    config = function()
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = '*',
        callback = function(args)
          require('conform').format { bufnr = args.buf }
        end,
      })
    end,

    -- stylua: ignore
    keymaps = {
      { map = '<leader>cf', cmd = function() require('conform').format() end, desc = 'Code (Conform) format', mode = { 'n', 'v', 'x' } },
    },
  }),

  Plug.new('https://github.com/sindrets/diffview.nvim', 'diffview', {
    opts = {},

    -- stylua: ignore
    keymaps = {
      { map = '<leader>gD', cmd = '<cmd>DiffviewOpen<cr>',  desc = 'Open Git Diff View' },
      { map = '<leader>gC', cmd = '<cmd>DiffviewClose<cr>', desc = 'Close Git Diff View' },
    },
  }),

  Plug.new('https://github.com/elixir-tools/elixir-tools.nvim', 'elixir-tools.nvim', { opts = {} }),

  Plug.new('https://github.com/RRethy/nvim-treesitter-endwise', 'nvim-treesitter-endwise', {}),

  Plug.new('https://github.com/L3MON4D3/LuaSnip', 'LuaSnip', {}),

  Plug.new('https://github.com/lewis6991/gitsigns.nvim', 'gitsigns', {

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
      signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
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
    },

    -- stylua: ignore
    keymaps = {
      { map = '<leader>tb', cmd = function() require('gitsigns').toggle_current_line_blame() end, desc = 'Toggle Current Line Blame' },
      { map = '<leader>td', cmd = function() require('gitsigns').toggle_deleted() end,            desc = 'Toggle Deleted' },
      { map = '<leader>tw', cmd = function() require('gitsigns').toggle_word_diff() end,          desc = 'Toggle Word Diff' },
      { map = '<leader>td', cmd = function() require('gitsigns').diffthis() end,                  desc = 'Toggle Diff of This File' },
      { map = 'ih',         cmd = ':<C-U>Gitsigns select_hunk<CR>',                               desc = 'Select hunk',              mode = { 'o', 'x' } },
      { map = ']c',         cmd = ':<C-U>Gitsigns next_hunk<CR>',                                 desc = 'Navigate To Next Hunk' },
      { map = '[c',         cmd = ':<C-U>Gitsigns prev_hunk<CR>',                                 desc = 'Navigate To Previous Hunk' },
    },
  }),

  Plug.new('https://github.com/echasnovski/mini.nvim', 'mini.nvim', {

    config = function()
      require('mini.pairs').setup()
      require('mini.surround').setup()
      require('mini.ai').setup()
      require('mini.move').setup()
      require('mini.operators').setup()
      require('mini.comment').setup()
      require('mini.jump').setup()
      require('mini.icons').setup()
    end,
  }),
  Plug.new('https://github.com/nvim-neotest/neotest', 'neotest', {

    deps = {
      'https://github.com/nvim-neotest/nvim-nio',
      'https://github.com/antoinemadec/FixCursorHold.nvim',
      'https://github.com/fredrikaverpil/neotest-golang',
      'https://github.com/jfpedroza/neotest-elixir',
      'https://github.com/nvim-neotest/neotest-python',
      'https://github.com/rcasia/neotest-java',
      'https://github.com/folke/trouble.nvim',
    },

    opts = {
      nextls = { enable = false },
      elixirls = { enable = true },
      projectionist = { enable = true },
    },

    config = function()
      require('trouble').setup()
    end,

    -- stylua: ignore
    keymaps = {
      { map = "<leader>t",  cmd = "",                                                                                 desc = "+test" },
      { map = "<leader>tt", cmd = function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File (Neotest)" },
      { map = "<leader>tT", cmd = function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files (Neotest)" },
      { map = "<leader>tr", cmd = function() require("neotest").run.run() end,                                        desc = "Run Nearest (Neotest)" },
      { map = "<leader>tl", cmd = function() require("neotest").run.run_last() end,                                   desc = "Run Last (Neotest)" },
      { map = "<leader>ts", cmd = function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary (Neotest)" },
      { map = "<leader>to", cmd = function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
      { map = "<leader>tO", cmd = function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel (Neotest)" },
      { map = "<leader>tS", cmd = function() require("neotest").run.stop() end,                                       desc = "Stop (Neotest)" },
      { map = "<leader>tw", cmd = function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch (Neotest)" },
    }
,
  }),

  Plug.new('https://github.com/nvim-lua/plenary.nvim', 'plenary.nvim', {}),

  Plug.new('https://github.com/rose-pine/neovim', 'rose-pine', {

    opts = {
      -- options for the rose-pine theme
      variant = 'auto', -- auto, main, moon, or dawn
      dark_variant = 'main', -- main, moon, or dawn
      dim_inactive_windows = false,
      extend_background_behind_borders = false,
      styles = {
        bold = false,
        italic = false,
        transparency = false,
      },
    },

    config = function()
      vim.cmd.colorscheme 'rose-pine'
    end,
  }),

  Plug.new('https://github.com/sschleemilch/slimline.nvim', 'slimline', { opts = { style = 'fg' } }),

  Plug.new('https://github.com/folke/snacks.nvim', 'snacks', {

    opts = {
      quickfile = { enabled = true },
      picker = { enabled = true },
    },

    config = function()
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
    end,

    -- stylua: ignore
    keymaps = {
      { map = '<leader>z',       cmd = function() Snacks.zen() end,                                           desc = 'Toggle Zen Mode' },
      { map = '<leader>Z',       cmd = function() Snacks.zen.zoom() end,                                      desc = 'Toggle Zoom' },
      { map = '<leader>.',       cmd = function() Snacks.scratch() end,                                       desc = 'Toggle Scratch Buffer' },
      { map = '<leader>S',       cmd = function() Snacks.scratch.select() end,                                desc = 'Select Scratch Buffer' },
      { map = '<leader>n',       cmd = function() Snacks.notifier.show_history() end,                         desc = 'Notification History' },
      { map = '<leader>bd',      cmd = function() Snacks.bufdelete() end,                                     desc = 'Delete Buffer' },
      { map = '<leader>cR',      cmd = function() Snacks.rename.rename_file() end,                            desc = 'Rename File' },
      { map = '<leader>gB',      cmd = function() Snacks.gitbrowse() end,                                     desc = 'Git Browse',                  mode = { "n", "v" } },
      { map = '<leader>gb',      cmd = function() Snacks.git.blame_line() end,                                desc = 'Git Blame Line' },
      { map = '<leader>gf',      cmd = function() Snacks.lazygit.log_file() end,                              desc = 'Lazygit Current File History' },
      { map = '<leader>gg',      cmd = function() Snacks.lazygit() end,                                       desc = 'Lazygit' },
      { map = '<leader>gl',      cmd = function() Snacks.lazygit.log() end,                                   desc = 'Lazygit Log (cwd)' },
      { map = '<leader>un',      cmd = function() Snacks.notifier.hide() end,                                 desc = 'Dismiss All Notifications' },
      { map = ']]',              cmd = function() Snacks.words.jump(vim.v.count1) end,                        desc = 'Next Reference',              mode = { "n", "t" } },
      { map = '[[',              cmd = function() Snacks.words.jump(-vim.v.count1) end,                       desc = 'Prev Reference',              mode = { "n", "t" } },

      -- Top Pickers & Explorer
      { map = '<leader><space>', cmd = function() Snacks.picker.smart() end,                                  desc = 'Smart Find Files' },
      { map = '<leader>,',       cmd = function() Snacks.picker.buffers() end,                                desc = 'Buffers' },
      { map = '<leader>/',       cmd = function() Snacks.picker.grep() end,                                   desc = 'Grep' },
      { map = '<leader>:',       cmd = function() Snacks.picker.command_history() end,                        desc = 'Command History' },
      { map = '<leader>n',       cmd = function() Snacks.picker.notifications() end,                          desc = 'Notification History' },
      { map = "\\",              cmd = function() Snacks.explorer() end,                                      desc = 'File Explorer' },
      { map = '<leader>e',       cmd = function() Snacks.explorer.reveal() end,                               desc = 'File Explorer' },

      -- find
      { map = '<leader>fb',      cmd = function() Snacks.picker.buffers() end,                                desc = 'Buffers' },
      { map = '<leader>fc',      cmd = function() Snacks.picker.files({ cwd = vim.fn.stdpath 'config' }) end, desc = 'Find Config File' },
      { map = '<leader>ff',      cmd = function() Snacks.picker.files() end,                                  desc = 'Find Files' },
      { map = '<leader>fg',      cmd = function() Snacks.picker.git_files() end,                              desc = 'Find Git Files' },
      { map = '<leader>fp',      cmd = function() Snacks.picker.projects() end,                               desc = 'Projects' },
      { map = '<leader>fr',      cmd = function() Snacks.picker.recent() end,                                 desc = 'Recent' },

      -- git
      { map = '<leader>gb',      cmd = function() Snacks.picker.git_branches() end,                           desc = 'Git Branches' },
      { map = '<leader>gl',      cmd = function() Snacks.picker.git_log() end,                                desc = 'Git Log' },
      { map = '<leader>gL',      cmd = function() Snacks.picker.git_log_line() end,                           desc = 'Git Log Line' },
      { map = '<leader>gs',      cmd = function() Snacks.picker.git_status() end,                             desc = 'Git Status' },
      { map = '<leader>gS',      cmd = function() Snacks.picker.git_stash() end,                              desc = 'Git Stash' },
      { map = '<leader>gd',      cmd = function() Snacks.picker.git_diff() end,                               desc = 'Git Diff (Hunks)' },
      { map = '<leader>gf',      cmd = function() Snacks.picker.git_log_file() end,                           desc = 'Git Log File' },

      -- Grep
      { map = '<leader>sb',      cmd = function() Snacks.picker.lines() end,                                  desc = 'Buffer Lines' },
      { map = '<leader>sB',      cmd = function() Snacks.picker.grep_buffers() end,                           desc = 'Grep Open Buffers' },
      { map = '<leader>sg',      cmd = function() Snacks.picker.grep() end,                                   desc = 'Grep' },
      { map = '<leader>sw',      cmd = function() Snacks.picker.grep_word() end,                              desc = 'Visual selection or word',    mode = { "n", "x" } },

      -- search
      { map = '<leader>s"',      cmd = function() Snacks.picker.registers() end,                              desc = 'Registers' },
      { map = '<leader>s/',      cmd = function() Snacks.picker.search_history() end,                         desc = 'Search History' },
      { map = '<leader>sa',      cmd = function() Snacks.picker.autocmds() end,                               desc = 'Autocmds' },
      { map = '<leader>sb',      cmd = function() Snacks.picker.lines() end,                                  desc = 'Buffer Lines' },
      { map = '<leader>sc',      cmd = function() Snacks.picker.command_history() end,                        desc = 'Command History' },
      { map = '<leader>sC',      cmd = function() Snacks.picker.commands() end,                               desc = 'Commands' },
      { map = '<leader>sd',      cmd = function() Snacks.picker.diagnostics() end,                            desc = 'Diagnostics' },
      { map = '<leader>sD',      cmd = function() Snacks.picker.diagnostics_buffer() end,                     desc = 'Buffer Diagnostics' },
      { map = '<leader>sh',      cmd = function() Snacks.picker.help() end,                                   desc = 'Help Pages' },
      { map = '<leader>sH',      cmd = function() Snacks.picker.highlights() end,                             desc = 'Highlights' },
      { map = '<leader>si',      cmd = function() Snacks.picker.icons() end,                                  desc = 'Icons' },
      { map = '<leader>sj',      cmd = function() Snacks.picker.jumps() end,                                  desc = 'Jumps' },
      { map = '<leader>sk',      cmd = function() Snacks.picker.keymaps() end,                                desc = 'Keymaps' },
      { map = '<leader>sl',      cmd = function() Snacks.picker.loclist() end,                                desc = 'Location List' },
      { map = '<leader>sm',      cmd = function() Snacks.picker.marks() end,                                  desc = 'Marks' },
      { map = '<leader>sM',      cmd = function() Snacks.picker.man() end,                                    desc = 'Man Pages' },
      { map = '<leader>sp',      cmd = function() Snacks.picker.lazy() end,                                   desc = 'Search for Plugin Spec' },
      { map = '<leader>sq',      cmd = function() Snacks.picker.qflist() end,                                 desc = 'Quickfix List' },
      { map = '<leader>sR',      cmd = function() Snacks.picker.resume() end,                                 desc = 'Resume' },
      { map = '<leader>su',      cmd = function() Snacks.picker.undo() end,                                   desc = 'Undo History' },
      { map = '<leader>uC',      cmd = function() Snacks.picker.colorschemes() end,                           desc = 'Colorschemes' },

      -- LSP
      { map = 'gd',              cmd = function() Snacks.picker.lsp_definitions() end,                        desc = 'Goto Definition' },
      { map = 'gD',              cmd = function() Snacks.picker.lsp_declarations() end,                       desc = 'Goto Declaration' },
      { map = 'gR',              cmd = function() Snacks.picker.lsp_references() end,                         desc = 'References' },
      { map = 'gI',              cmd = function() Snacks.picker.lsp_implementations() end,                    desc = 'Goto Implementation' },
      { map = 'gy',              cmd = function() Snacks.picker.lsp_type_definitions() end,                   desc = 'Goto T[y]pe Definition' },
      { map = '<leader>ss',      cmd = function() Snacks.picker.lsp_symbols() end,                            desc = 'LSP Symbols' },
      { map = '<leader>sS',      cmd = function() Snacks.picker.lsp_workspace_symbols() end,                  desc = 'LSP Workspace Symbols' },
    },
  }),

  Plug.new('https://github.com/supermaven-inc/supermaven-nvim', 'supermaven-nvim', {

    deps = {
      'https://github.com/onsails/lspkind.nvim',
    },

    opts = {
      keymaps = {
        accept_suggestion = '<Tab>',
        clear_suggestion = '<C-h>',
        accept_word = '<C-l>',
      },
      ignore_filetypes = { cpp = true }, -- or { "cpp", }
      color = {
        suggestion_color = '#000508',
        cterm = 244,
      },
      log_level = 'off', -- set to "off" to disable logging completely
      disable_inline_completion = false, -- disables inline completion for use with cmp
      disable_keymaps = false, -- disables built in keymaps for more manual control
      condition = function()
        return false
      end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
    },

    config = function()
      require('lspkind').init {
        symbol_map = {
          Supermaven = '',
        },
      }

      vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })
    end,
  }),

  Plug.new('https://github.com/nvim-treesitter/nvim-treesitter', 'nvim-treesitter', {

    config = function()
      local ts_update = require('nvim-treesitter.install').update { with_sync = true }
      ts_update()

      local treesitter_config = require 'nvim-treesitter.configs'
      treesitter_config.setup {
        ensure_installed = {
          'c',
          'lua',
          'vim',
          'vimdoc',
          'query',
          'elixir',
          'heex',
          'javascript',
          'html',
          'go',
          'gomod',
          'gosum',
          'git_config',
          'gitcommit',
          'git_rebase',
          'gitignore',
          'diff',
          'zig',
          'markdown',
          'python',
        },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        auto_install = true,
      }
    end,
  }),

  Plug.new('https://github.com/kevinhwang91/nvim-ufo', 'ufo', {

    deps = {
      'https://github.com/kevinhwang91/promise-async',
    },

    opts = {
      provider_selector = function(bufnr, filetype, buftype)
        return { 'treesitter', 'indent' }
      end,
    },

    config = function()
      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
    end,

    -- stylua: ignore
    keymaps = {
      { map = 'zR', cmd = function() require('ufo').openAllFolds() end,  desc = 'Open all folds' },
      { map = 'zM', cmd = function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
    },
  }),

  Plug.new('https://github.com/tummetott/unimpaired.nvim', 'unimpaired', { opts = {} }),
}

-- Install plugins
Plug.installAll(plugins)

-- stylua: ignore
---@type Keymaps
local keymaps = {
  --- Yank and paste from system clipboard
  { map = '<leader>y',  cmd = '"+y',                    desc = 'Yank (Clipboard)',   mode = { "v", "x" } },
  { map = '<leader>Y',  cmd = '"+Y',                    desc = 'Yank (Clipboard)',   mode = { "v", "x" } },
  { map = '<leader>p',  cmd = '"+p',                    desc = 'Paste (Clipboard)',  mode = { "v", "x" } },
  { map = '<leader>P',  cmd = '"+P',                    desc = 'Paste (Clipboard)',  mode = { "v", "x" } },

  --- Navigate vim panes better
  { map = '<c-k>',      cmd = ':wincmd k<CR>',          desc = 'Move to top pane' },
  { map = '<c-j>',      cmd = ':wincmd j<CR>',          desc = 'Move to bottom pane' },
  { map = '<c-h>',      cmd = ':wincmd h<CR>',          desc = 'Move to left pane' },
  { map = '<c-l>',      cmd = ':wincmd l<CR>',          desc = 'Move to right pane' },
  { map = '<leader>o',  cmd = ':update<CR> :source<CR>' },

  --- LSP
  { map = 'gD',         cmd = vim.lsp.buf.declaration,  desc = 'Goto Declaration',   mode = { 'n' } },
  { map = '<leader>cr', cmd = vim.lsp.buf.rename,       desc = 'Code Rename',        mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action,  desc = 'Code Action',        mode = { 'n', 'v' } },
}

-- Setup plugins
for _, plugin in ipairs(plugins) do
  local ok, result = pcall(function()
    plugin:setup()
  end)

  if not ok then
    vim.notify(('Fail to setup the plugin: %s\n'):format(plugin.name or 'Unknown'))
    vim.inspect(result)
  end

  if plugin.opts.keymaps then
    vim.list_extend(keymaps, plugin.opts.keymaps)
  end
end

-- Setup keymaps
Keymap.check_conflicts(keymaps)
Keymap.set_keymaps(keymaps)
