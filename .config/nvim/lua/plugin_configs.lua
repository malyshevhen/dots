--- Init

-- Alpha
require('alpha').opts(require('alpha.themes.dashboard').config)

-- Slimline
require('slimline').opts { style = 'fg' }

-- Autopairs
require('nvim-autopairs').setup { map_cr = true }

-- Treesitter
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

-- Theme
require('rose-pine').setup {
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
}
vim.cmd.colorscheme 'rose-pine'

-- Conform
require('conform').opts {
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
}

-- vim.api.nvim_create_user_command('CopyRelPath', "call setreg('+', expand('%'))", {})

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format { bufnr = args.buf }
  end,
})

-- Supermaven
require('supermaven-nvim').setup {
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
}

require('lspkind').init {
  symbol_map = {
    Supermaven = '',
  },
}

vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })

-- Gitsigns
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
    -- map('n', '<leader>gs', git_signs.stage_hunk, { desc = 'Stage Hunk' })
    -- map('n', '<leader>gr', git_signs.reset_hunk, { desc = 'Reset Hunk' })
    --
    -- map('v', '<leader>gs', function()
    --   git_signs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
    -- end, { desc = 'Stage Hunk' })
    --
    -- map('v', '<leader>gr', function()
    --   git_signs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
    -- end, { desc = 'Reset Hunk' })
    --
    -- map('n', '<leader>gS', git_signs.stage_buffer, { desc = 'Stage Buffer' })
    -- map('n', '<leader>gR', git_signs.reset_buffer, { desc = 'Reset Buffer' })
    -- map('n', '<leader>gp', git_signs.preview_hunk, { desc = 'Preview Hunk' })
    -- map('n', '<leader>gi', git_signs.preview_hunk_inline, { desc = 'Preview Hunk Inline' })
    --
    -- map('n', '<leader>hb', function()
    --   git_signs.blame_line { full = true }
    -- end, { desc = 'Blame Line' })
    --
    -- map('n', '<leader>gd', git_signs.diffthis, { desc = 'Diff This File' })
    -- map('n', '<leader>gD', function()
    --   git_signs.diffthis '~'
    -- end, { desc = 'Diff This File (cached)' })
    -- map('n', '<leader>gQ', function()
    --   git_signs.setqflist 'all'
    -- end, { desc = 'Set QuickFix List To All Hunks' })
    -- map('n', '<leader>gq', git_signs.setqflist, { desc = 'Set QuickFix List To Current Hunks' })

    -- Toggles
    map('n', '<leader>tb', git_signs.toggle_current_line_blame, { desc = 'Toggle Current Line Blame' })
    map('n', '<leader>td', git_signs.toggle_deleted, { desc = 'Toggle Deleted' })
    map('n', '<leader>tw', git_signs.toggle_word_diff, { desc = 'Toggle Word Diff' })
    map('n', '<leader>td', git_signs.diffthis, { desc = 'Toggle Diff of This File' })

    -- Text object
    map({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'Select hunk' })
  end,
}

-- Unimpaired
require('unimpaired').setup()

-- Ufo
vim.o.foldcolumn = '1' -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
}

-- Mini
require('mini.pairs').setup()
require('mini.surround').setup()
require('mini.ai').setup()
require('mini.move').setup()
require('mini.operators').setup()
require('mini.comment').setup()
require('mini.jump').setup()
require('mini.icons').setup()

-- Diffview
require('diffview').setup()

-- Auto-session
require('auto-session').setup {
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  auto_restore = false,
  auto_restore_last_session = false,
}

-- Snacks
require('snacks').setup {
  quickfile = { enabled = true },
  picker = { enabled = true },
}

local Snacks = Snacks

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

-- Elixir tools
require('elixir').setup {
  nextls = { enable = false },
  elixirls = { enable = true },
  projectionist = { enable = true },
}

-- Trouble
require('trouble').setup()

-- Neotest
local opts = {
  adapters = {
    ['neotest-golang'] = {
      go_test_args = { '-v', '-race', '-count=1', '-timeout=60s' },
      dap_go_enabled = true,
    },
    ['neotest-elixir'] = {},
    ['neotest-python'] = {},
    ['neotest-java'] = {},
  },
  status = { virtual_text = true },
  output = { open_on_run = true },
  quickfix = {
    open = function()
      require('trouble').open { mode = 'quickfix', focus = false }
    end,
  },
}

local neotest_ns = vim.api.nvim_create_namespace 'neotest'
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      -- Replace newline and tab characters with space for more compact diagnostics
      local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
      return message
    end,
  },
}, neotest_ns)

opts.consumers = opts.consumers or {}
-- Refresh and auto close trouble after running tests
---@type neotest.Consumer
opts.consumers.trouble = function(client)
  client.listeners.results = function(adapter_id, results, partial)
    if partial then
      return
    end
    local tree = assert(client:get_position(nil, { adapter = adapter_id }))

    local failed = 0
    for pos_id, result in pairs(results) do
      if result.status == 'failed' and tree:get_key(pos_id) then
        failed = failed + 1
      end
    end
    vim.schedule(function()
      local trouble = require 'trouble'
      if trouble.is_open() then
        trouble.refresh()
        if failed == 0 then
          trouble.close()
        end
      end
    end)
  end

  return {}
end

if opts.adapters then
  local adapters = {}
  for name, config in pairs(opts.adapters or {}) do
    if type(name) == 'number' then
      if type(config) == 'string' then
        config = require(config)
      end
      adapters[#adapters + 1] = config
    elseif config ~= false then
      local adapter = require(name)
      if type(config) == 'table' and not vim.tbl_isempty(config) then
        local meta = getmetatable(adapter)
        if adapter.setup then
          adapter.setup(config)
        elseif adapter.adapter then
          adapter.adapter(config)
          adapter = adapter.adapter
        elseif meta and meta.__call then
          adapter = adapter(config)
        else
          error('Adapter ' .. name .. ' does not support setup')
        end
      end
      adapters[#adapters + 1] = adapter
    end
  end
  opts.adapters = adapters
end

require('neotest').setup(opts)
