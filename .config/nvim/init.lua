--------------------------------------------------------------------------------
-------------------------------- INIT ------------------------------------------
--------------------------------------------------------------------------------
local simple_pm = require 'simple_pm'

-- Set up the plugin management system with automatic configuration sourcing
simple_pm.init {
  auto_source_configs = true,
  auto_setup_keymaps = true,
  debug_mode = false, -- Set to true for debugging
}

--------------------------------------------------------------------------------
-------------------------------- OPTIONS ---------------------------------------
--------------------------------------------------------------------------------

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.opt.signcolumn = 'yes'
vim.cmd 'set expandtab'
vim.cmd 'set completeopt=noselect'
vim.opt.winborder = 'rounded'
vim.api.nvim_set_option_value('clipboard', 'unnamed', {})
-- set faster completion
vim.opt.updatetime = 60
-- disable backup file creation
vim.opt.backup = false
-- prevent editing of files being edited elsewhere
vim.opt.writebackup = false
-- Removes tilde symbols from the end of the page
vim.opt.fillchars = { eob = ' ' }
vim.opt.swapfile = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 10
-- Nerd Fonts
vim.g.have_nerd_font = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'
-- Save undo history
vim.opt.undofile = true
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
-- Show which line your cursor is on
vim.opt.cursorline = true
-- Disable line wraps
vim.opt.wrap = false
vim.cmd 'filetype plugin indent on'

--------------------------------------------------------------------------------
-------------------------------- AUTO COMMANDS ---------------------------------
--------------------------------------------------------------------------------

--- Highlight when yanking (copying) text
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('Highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--------------------------------------------------------------------------------
-------------------------------- FILETYPES -------------------------------------
--------------------------------------------------------------------------------

--- Add filetype mapping --- TODO: move to plugins.toml
vim.filetype.add {
  pattern = {
    ['docker-compose%.yml'] = 'yaml.docker-compose',
    ['docker-compose%.yaml'] = 'yaml.docker-compose',
    ['compose%.yml'] = 'yaml.docker-compose',
    ['compose%.yaml'] = 'yaml.docker-compose',
    ['*.raml'] = 'raml',
  },
}

--------------------------------------------------------------------------------
-------------------------------- LSP -------------------------------------------
--------------------------------------------------------------------------------

--------------------------------------------------------------------------------
-------------------------------- DIAGNOSTICS -----------------------------------
--------------------------------------------------------------------------------

vim.diagnostic.config {
  virtual_lines = {
    current_line = true,
  },
}

--------------------------------------------------------------------------------
-------------------------------- PLUGINS ---------------------------------------
--------------------------------------------------------------------------------

--- Dashboard
require('alpha').setup(require('alpha.themes.dashboard').config)

--- Session Management
require('auto-session').setup {
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

--- Completion
require('blink.cmp').setup {
  keymap = { preset = 'enter' },
  appearance = {
    -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
    -- Adjusts spacing to ensure icons are aligned
    nerd_font_variant = 'mono',
  },
  completion = { documentation = { auto_show = false } },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
  fuzzy = { implementation = 'lua' },
  signature = { enabled = true },
}

--- Formatting
require('conform').setup {
  formatters_by_ft = {
    lua = { 'stylua', lsp_format = 'first' },
    rust = { 'rustfmt', lsp_format = 'fallback' },
    javascript = { 'prettierd', 'prettier', stop_after_first = true },
    typescript = { 'prettierd', 'prettier', stop_after_first = true },
    javascriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    typescriptreact = { 'prettierd', 'prettier', stop_after_first = true },
    go = { 'goimports', 'gofmt' },
    java = { 'google-java-format' },
    sh = { 'shfmt' },
    bash = { 'shfmt' },
    zsh = { 'shfmt' },
    gleam = { 'gleam format', lsp_format = 'fallback' },
    elixir = { 'mix format', lsp_format = 'fallback' },
    python = { 'ruff_format', 'ruff_fix', 'ruff_imports', lsp_format = 'fallback' },
    toml = { 'taplo' },
    yaml = { 'prettierd', 'prettier', stop_after_first = true },
    json = { 'prettierd', 'prettier', stop_after_first = true },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    html = { 'prettierd', 'prettier', stop_after_first = true },
    css = { 'prettierd', 'prettier', stop_after_first = true },
    scss = { 'prettierd', 'prettier', stop_after_first = true },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
  },
  format_on_save = {
    timeout_ms = 100,
    lsp_format = 'fallback',
  },
  default_format_opts = {
    lsp_format = 'fallback',
  },
}

-- Format on save autocmd
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = '*',
  callback = function(args)
    require('conform').format {
      bufnr = args.buf,
      async = false,
      timeout_ms = 500,
    }
  end,
})

--- Git
--- diffview
require('diffview').setup {
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
}
---gitsigns
require('gitsigns').setup {
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

--- Snippets
require('luasnip').config.setup {
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [require('luasnip.util.types').choiceNode] = {
      active = {
        virt_text = { { '<-', 'Error' } },
      },
    },
  },
}

--- Mini.nvim
require('mini.pairs').setup()
require('mini.move').setup {
  mappings = {
    left = '<M-h>',
    right = '<M-l>',
    down = '<M-j>',
    up = '<M-k>',

    line_left = '<M-h>',
    line_right = '<M-l>',
    line_down = '<M-j>',
    line_up = '<M-k>',
  },

  options = {
    reindent_linewise = true,
  },
}
require('mini.operators').setup()
require('mini.comment').setup()
-- require('mini.icons').setup()

--- Testing
require('neotest').setup {
  -- adapters will be configured dynamically in config function
  discovery = {
    enabled = true,
    concurrent = 1,
  },
  diagnostic = {
    enabled = true,
    severity = 1,
  },
  floating = {
    border = 'rounded',
    max_height = 0.6,
    max_width = 0.6,
    options = {},
  },
  highlights = {
    adapter_name = 'NeotestAdapterName',
    border = 'NeotestBorder',
    dir = 'NeotestDir',
    expand_marker = 'NeotestExpandMarker',
    failed = 'NeotestFailed',
    file = 'NeotestFile',
    focused = 'NeotestFocused',
    indent = 'NeotestIndent',
    marked = 'NeotestMarked',
    namespace = 'NeotestNamespace',
    passed = 'NeotestPassed',
    running = 'NeotestRunning',
    select_win = 'NeotestWinSelect',
    skipped = 'NeotestSkipped',
    target = 'NeotestTarget',
    test = 'NeotestTest',
    unknown = 'NeotestUnknown',
    watching = 'NeotestWatching',
  },
  icons = {
    child_indent = '│',
    child_prefix = '├',
    collapsed = '─',
    expanded = '╮',
    failed = '✖',
    final_child_indent = ' ',
    final_child_prefix = '╰',
    non_collapsible = '─',
    passed = '✓',
    running = '●',
    running_animated = { '/', '|', '\\', '-', '/', '|', '\\', '-' },
    skipped = '○',
    unknown = '?',
    watching = '👁',
  },
  output = {
    enabled = true,
    open_on_run = 'short',
  },
  output_panel = {
    enabled = true,
    open = 'botright split | resize 15',
  },
  quickfix = {
    enabled = true,
    open = false,
  },
  run = {
    enabled = true,
  },
  running = {
    concurrent = true,
  },
  state = {
    enabled = true,
  },
  status = {
    enabled = true,
    signs = true,
    virtual_text = false,
  },
  strategies = {
    integrated = {
      height = 40,
      width = 120,
    },
  },
  summary = {
    animated = true,
    enabled = true,
    expand_errors = true,
    follow = true,
    mappings = {
      attach = 'a',
      clear_marked = 'M',
      clear_target = 'T',
      debug = 'd',
      debug_marked = 'D',
      expand = { '<CR>', '<2-LeftMouse>' },
      expand_all = 'e',
      help = '?',
      jumpto = 'i',
      mark = 'm',
      next_failed = 'J',
      output = 'o',
      prev_failed = 'K',
      run = 'r',
      run_marked = 'R',
      short = 'O',
      stop = 'u',
      target = 't',
      watch = 'w',
    },
    open = 'botright vsplit | vertical resize 50',
  },
  watch = {
    enabled = true,
    symbol_queries = {
      python = [[
          (function_definition
            name: (identifier) @symbol.name) @symbol.definition
          (class_definition
            name: (identifier) @symbol.name) @symbol.definition
        ]],
      javascript = [[
          (function_declaration
            name: (identifier) @symbol.name) @symbol.definition
          (method_definition
            name: (property_identifier) @symbol.name) @symbol.definition
          (arrow_function) @symbol.definition
        ]],
      typescript = [[
          (function_declaration
            name: (identifier) @symbol.name) @symbol.definition
          (method_definition
            name: (property_identifier) @symbol.name) @symbol.definition
          (arrow_function) @symbol.definition
        ]],
      go = [[
          (function_declaration
            name: (identifier) @symbol.name) @symbol.definition
          (method_declaration
            name: (field_identifier) @symbol.name) @symbol.definition
        ]],
      elixir = [[
          (call
            target: (identifier) @symbol.name (#match? @symbol.name "^(test|describe)$")) @symbol.definition
        ]],
      java = [[
          (method_declaration
            name: (identifier) @symbol.name) @symbol.definition
          (class_declaration
            name: (identifier) @symbol.name) @symbol.definition
        ]],
      rust = [[
          (function_item
            name: (identifier) @symbol.name) @symbol.definition
          (impl_item
            type: (type_identifier) @symbol.name) @symbol.definition
        ]],
    },
  },
}

-- Set up trouble.nvim integration
local ok_trouble, trouble = pcall(require, 'trouble')
if ok_trouble then
  trouble.setup()
end

-- Simple adapter configuration
local adapters = {}

-- Only add adapters that are actually available
local adapter_configs = {
  {
    name = 'neotest-python',
    executable = 'python',
    config = {
      dap = { justMyCode = false },
      args = { '--log-level', 'DEBUG' },
      runner = 'pytest',
    },
  },
  {
    name = 'neotest-golang',
    executable = 'go',
    config = {},
  },
  {
    name = 'neotest-elixir',
    executable = 'mix',
    config = {
      -- Environment configuration to prevent output parsing issues
      env = {
        MIX_ENV = 'test',
        NO_COLOR = '1',
      },
      -- Use minimal args focused on reliable output
      args = {
        '--formatter',
        'ExUnit.CLIFormatter',
        '--no-deps-check',
        '--max-failures',
        '1000',
      },
    },
  },
  {
    name = 'neotest-java',
    executable = 'mvn',
    config = {},
  },
  {
    name = 'neotest-jest',
    executable = 'npm',
    config = {
      jestCommand = 'npm test --',
      env = { CI = true },
      cwd = function()
        return vim.fn.getcwd()
      end,
    },
  },
  {
    name = 'neotest-vitest',
    executable = 'npm',
    config = {},
  },
}

for _, adapter_info in ipairs(adapter_configs) do
  if vim.fn.executable(adapter_info.executable) == 1 then
    local ok, adapter = pcall(require, adapter_info.name)
    if ok then
      if next(adapter_info.config) then
        table.insert(adapters, adapter(adapter_info.config))
      else
        table.insert(adapters, adapter)
      end
    end
  end
end

-- Simple configuration
local neotest_config = {
  adapters = adapters,
  discovery = { enabled = true },
  diagnostic = { enabled = true },
  output = { enabled = true, open_on_run = 'short' },
  quickfix = { enabled = true, open = false },
  status = { enabled = true, signs = true, virtual_text = false },
  summary = { enabled = true, animated = true },
}

local ok_neotest, neotest = pcall(require, 'neotest')
if ok_neotest then
  neotest.setup(neotest_config)
end

--- Theme
require('rose-pine').setup {
  variant = 'auto',
  dark_variant = 'main',
  dim_inactive_windows = false,
  extend_background_behind_borders = false,
  styles = {
    bold = false,
    italic = false,
    transparency = false,
  },
}

vim.cmd.colorscheme 'rose-pine'

--- Status line
require('slimline').setup { style = 'fg' }

--- Picker and File tree
require('snacks').setup {
  quickfile = { enabled = true },
  picker = { enabled = true },
}

vim.api.nvim_create_autocmd('User', {
  pattern = 'VeryLazy',
  callback = function()
    local Snacks = Snacks
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
    -- stylua: ignore
    Snacks.toggle.option('conceallevel', { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2, }):map '<leader>uc'
    Snacks.toggle.treesitter():map '<leader>uT'
    -- stylua: ignore
    Snacks.toggle.option('background', { off = 'light', on = 'dark', name = 'Dark Background', }):map '<leader>ub'
    Snacks.toggle.inlay_hints():map '<leader>uh'
    Snacks.toggle.indent():map '<leader>ug'
    Snacks.toggle.dim():map '<leader>uD'
  end,
})

-- AI Suggestions
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

--- Treesitter
local ts_update = require('nvim-treesitter.install').update { with_sync = true }
ts_update()

require('nvim-treesitter.configs').setup {
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

--- Autoclose delimiters
require('nvim-treesitter.configs').setup { endwise = { enable = true } }

--- Folds
require('ufo').setup {
  provider_selector = function(bufnr, filetype, buftype)
    return { 'treesitter', 'indent' }
  end,
}

vim.o.foldcolumn = '1'
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true

--- Illuminate
require('illuminate').configure {
  -- providers: provider used to get references in the buffer, ordered by priority
  providers = {
    'lsp',
    'treesitter',
    'regex',
  },
  -- delay: delay in milliseconds
  delay = 100,
  -- filetype_overrides: filetype specific overrides.
  -- The keys are strings to represent the filetype while the values are tables that
  -- supports the same keys passed to .configure except for filetypes_denylist and filetypes_allowlist
  filetype_overrides = {},
  -- filetypes_denylist: filetypes to not illuminate, this overrides filetypes_allowlist
  filetypes_denylist = {
    'dirbuf',
    'dirvish',
    'fugitive',
  },
  -- filetypes_allowlist: filetypes to illuminate, this is overridden by filetypes_denylist
  -- You must set filetypes_denylist = {} to override the defaults to allow filetypes_allowlist to take effect
  filetypes_allowlist = {},
  -- modes_denylist: modes to not illuminate, this overrides modes_allowlist
  -- See `:help mode()` for possible values
  modes_denylist = {},
  -- modes_allowlist: modes to illuminate, this is overridden by modes_denylist
  -- See `:help mode()` for possible values
  modes_allowlist = {},
  -- providers_regex_syntax_denylist: syntax to not illuminate, this overrides providers_regex_syntax_allowlist
  -- Only applies to the 'regex' provider
  -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  providers_regex_syntax_denylist = {},
  -- providers_regex_syntax_allowlist: syntax to illuminate, this is overridden by providers_regex_syntax_denylist
  -- Only applies to the 'regex' provider
  -- Use :echom synIDattr(synIDtrans(synID(line('.'), col('.'), 1)), 'name')
  providers_regex_syntax_allowlist = {},
  -- under_cursor: whether or not to illuminate under the cursor
  under_cursor = true,
  -- large_file_cutoff: number of lines at which to use large_file_config
  -- The `under_cursor` option is disabled when this cutoff is hit
  large_file_cutoff = 10000,
  -- large_file_config: config to use for large files (based on large_file_cutoff).
  -- Supports the same keys passed to .configure
  -- If nil, vim-illuminate will be disabled for large files.
  large_file_overrides = nil,
  -- min_count_to_highlight: minimum number of matches required to perform highlighting
  min_count_to_highlight = 1,
  -- should_enable: a callback that overrides all other settings to
  -- enable/disable illumination. This will be called a lot so don't do
  -- anything expensive in it.
  should_enable = function(bufnr)
    return true
  end,
  -- case_insensitive_regex: sets regex case sensitivity
  case_insensitive_regex = false,
  -- disable_keymaps: disable default keymaps
  disable_keymaps = false,
}

local Snacks = Snacks

--------------------------------------------------------------------------------
-------------------------------- KEYBINDINGS -----------------------------------
--------------------------------------------------------------------------------

-- stylua: ignore
K:map {
  -- System clipboard operations
  { map = '<leader>y',       cmd = '"+y',                                                                                     desc = 'Yank (Clipboard)',                mode = { 'v', 'x' } },
  { map = '<leader>Y',       cmd = '"+Y',                                                                                     desc = 'Yank (Clipboard)',                mode = { 'v', 'x' }, },
  { map = '<leader>p',       cmd = '"+p',                                                                                     desc = 'Paste (Clipboard)',               mode = { 'v', 'x' }, },
  { map = '<leader>P',       cmd = '"+P',                                                                                     desc = 'Paste (Clipboard)',               mode = { 'v', 'x' }, },

  -- Window navigation
  { map = '<c-k>',           cmd = ':wincmd k<CR>',                                                                           desc = 'Move to top pane' },
  { map = '<c-j>',           cmd = ':wincmd j<CR>',                                                                           desc = 'Move to bottom pane' },
  { map = '<c-h>',           cmd = ':wincmd h<CR>',                                                                           desc = 'Move to left pane' },
  { map = '<c-l>',           cmd = ':wincmd l<CR>',                                                                           desc = 'Move to right pane' },
  { map = '<leader>o',       cmd = ':update<CR> :source<CR>',                                                                 desc = 'Save and source file' },

  -- LSP operations
  { map = '<leader>cr',      cmd = vim.lsp.buf.rename,                                                                        desc = 'Code Rename',                     mode = { 'n' }, },
  { map = '<leader>ca',      cmd = vim.lsp.buf.code_action,                                                                   desc = 'Code Action',                     mode = { 'n', 'v' }, },

  -- AutoSession
  { map = '<leader>wr',      cmd = '<cmd>AutoSession search<CR>',                                                             desc = 'Session search' },
  { map = '<leader>ws',      cmd = '<cmd>AutoSession save<CR>',                                                               desc = 'Save session', },
  { map = '<leader>wa',      cmd = '<cmd>AutoSession toggle<CR>',                                                             desc = 'Toggle autosave', },
  { map = '<leader>wd',      cmd = '<cmd>AutoSession delete<CR>',                                                             desc = 'Delete session', },
  { map = '<leader>wD',      cmd = '<cmd>AutoSession purgeOrphaned<CR>',                                                      desc = 'Delete orphaned sessions', },
  { map = '<leader>wl',      cmd = '<cmd>AutoSession restore<CR>',                                                            desc = 'Load/Restore session', },

  -- Conform
  { map = '<leader>cf',      cmd = function() require('conform').format() end,                                                desc = 'Code (Conform) format',           mode = { 'n', 'v', 'x' }, },
  { map = '<leader>cF',      cmd = function() require('conform').format { async = true } end,                                 desc = 'Format async',                    mode = { 'n', 'v', 'x' }, },

  -- DiffView
  { map = '<leader>gD',      cmd = '<cmd>DiffviewOpen<cr>',                                                                   desc = 'Open Git Diff View', },
  { map = '<leader>gC',      cmd = '<cmd>DiffviewClose<cr>',                                                                  desc = 'Close Git Diff View', },
  { map = '<leader>gH',      cmd = '<cmd>DiffviewFileHistory<cr>',                                                            desc = 'Git File History', },
  { map = '<leader>gh',      cmd = '<cmd>DiffviewFileHistory %<cr>',                                                          desc = 'Git File History (current file)', },
  { map = '<leader>gR',      cmd = '<cmd>DiffviewRefresh<cr>',                                                                desc = 'Refresh Diff View', },
  { map = '<leader>gF',      cmd = '<cmd>DiffviewToggleFiles<cr>',                                                            desc = 'Toggle Files Panel', },
  { map = '<leader>gf',      cmd = '<cmd>DiffviewFocusFiles<cr>',                                                             desc = 'Focus Files Panel', },

  -- Gitsigns
  { map = '[c',              cmd = ':<C-U>Gitsigns next_hunk<CR>',                                                            desc = 'Previous Git Hunk', },
  { map = ']c',              cmd = ':<C-U>Gitsigns prev_hunk<CR>',                                                            desc = 'Next Git Hunk', },
  { map = '<leader>gs',      cmd = ':<C-U>Gitsigns select_hunk<CR>',                                                          desc = 'Toggle Git Signs', },
  { map = '<leader>gd',      cmd = function() require('gitsigns').toggle_deleted() end,                                       desc = 'Toggle Git Deleted', },
  { map = '<leader>gw',      cmd = function() require('gitsigns').toggle_word_diff() end,                                     desc = 'Toggle Git Word Diff', },

  -- Neotest
  -- Test running
  { map = '<leader>t',       cmd = '',                                                                                        desc = '+test', },
  { map = '<leader>tt',      cmd = function() require('neotest').run.run(vim.fn.expand '%') end,                              desc = 'Run File (Neotest)', },
  { map = '<leader>tT',      cmd = function() require('neotest').run.run(vim.uv.cwd()) end,                                   desc = 'Run All Test Files (Neotest)', },
  { map = '<leader>tr',      cmd = function() require('neotest').run.run() end,                                               desc = 'Run Nearest (Neotest)', },
  { map = '<leader>tl',      cmd = function() require('neotest').run.run_last() end,                                          desc = 'Run Last (Neotest)', },
  { map = '<leader>tS',      cmd = function() require('neotest').run.stop() end,                                              desc = 'Stop (Neotest)', },
  { map = '<leader>ta',      cmd = function() require('neotest').run.attach() end,                                            desc = 'Attach (Neotest)', },

  -- Test UI
  { map = '<leader>ts',      cmd = function() require('neotest').summary.toggle() end,                                        desc = 'Toggle Summary (Neotest)', },
  { map = '<leader>to',      cmd = function() require('neotest').output.open { enter = true, auto_close = true } end,         desc = 'Show Output (Neotest)', },
  { map = '<leader>tO',      cmd = function() require('neotest').output_panel.toggle() end,                                   desc = 'Toggle Output Panel (Neotest)', },

  -- Test watching
  { map = '<leader>tw',      cmd = function() require('neotest').watch.toggle(vim.fn.expand '%') end,                         desc = 'Toggle Watch (Neotest)', },
  { map = '<leader>tW',      cmd = function() require('neotest').watch.toggle(vim.uv.cwd()) end,                              desc = 'Toggle Watch All (Neotest)', },

  -- Test debugging
  { map = '<leader>td',      cmd = function() require('neotest').run.run { strategy = 'dap' } end,                            desc = 'Debug Nearest (Neotest)', },
  { map = '<leader>tD',      cmd = function() require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' } end,         desc = 'Debug File (Neotest)', },

  -- Test marks and targets
  { map = '<leader>tm',      cmd = function() require('neotest').run.run { suite = false, extra_args = { '--verbose' } } end, desc = 'Run Nearest with Args (Neotest)', },
  { map = '<leader>tM',      cmd = function() require('neotest').summary.run_marked() end,                                    desc = 'Run Marked Tests (Neotest)', },

  -- Navigation
  { map = ']t',              cmd = function() require('neotest').jump.next { status = 'failed' } end,                         desc = 'Next Failed Test', },
  { map = '[t',              cmd = function() require('neotest').jump.prev { status = 'failed' } end,                         desc = 'Previous Failed Test', },

  -- Snacks
  -- Core functionality
  { map = '<leader>z',       cmd = function() Snacks.zen() end,                                                               desc = 'Toggle Zen Mode', },
  { map = '<leader>Z',       cmd = function() Snacks.zen.zoom() end,                                                          desc = 'Toggle Zoom', },
  { map = '<leader>.',       cmd = function() Snacks.scratch() end,                                                           desc = 'Toggle Scratch Buffer', },
  { map = '<leader>S',       cmd = function() Snacks.scratch.select() end,                                                    desc = 'Select Scratch Buffer', },
  { map = '<leader>bd',      cmd = function() Snacks.bufdelete() end,                                                         desc = 'Delete Buffer', },
  { map = '<leader>cR',      cmd = function() Snacks.rename.rename_file() end,                                                desc = 'Rename File', },

  -- Navigation and pickers
  { map = '<leader><space>', cmd = function() Snacks.picker.smart() end,                                                      desc = 'Smart Find Files', },
  { map = '<leader>,',       cmd = function() Snacks.picker.buffers() end,                                                    desc = 'Buffers', },
  { map = '<leader>/',       cmd = function() Snacks.picker.grep() end,                                                       desc = 'Grep', },
  { map = '<leader>:',       cmd = function() Snacks.picker.command_history() end,                                            desc = 'Command History', },
  { map = '\\',              cmd = function() Snacks.explorer() end,                                                          desc = 'File Explorer', },
  { map = '<leader>e',       cmd = function() Snacks.explorer.reveal() end,                                                   desc = 'File Explorer', },

  -- File operations
  { map = '<leader>fb',      cmd = function() Snacks.picker.buffers() end,                                                    desc = 'Buffers', },
  { map = '<leader>fc',      cmd = function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end,                      desc = 'Find Config File', },
  { map = '<leader>ff',      cmd = function() Snacks.picker.files() end,                                                      desc = 'Find Files', },
  { map = '<leader>fg',      cmd = function() Snacks.picker.git_files() end,                                                  desc = 'Find Git Files', },
  { map = '<leader>fr',      cmd = function() Snacks.picker.recent() end,                                                     desc = 'Recent', },

  -- Git operations
  { map = '<leader>gB',      cmd = function() Snacks.gitbrowse() end,                                                         desc = 'Git Browse',                      mode = { 'n', 'v' }, },
  { map = '<leader>gb',      cmd = function() Snacks.git.blame_line() end,                                                    desc = 'Git Blame Line', },
  { map = '<leader>gg',      cmd = function() Snacks.lazygit() end,                                                           desc = 'Lazygit', },
  { map = '<leader>gl',      cmd = function() Snacks.lazygit.log() end,                                                       desc = 'Lazygit Log (cwd)', },

  -- Search operations
  { map = '<leader>sg',      cmd = function() Snacks.picker.grep() end,                                                       desc = 'Grep', },
  { map = '<leader>sw',      cmd = function() Snacks.picker.grep_word() end,                                                  desc = 'Visual selection or word',        mode = { 'n', 'x' }, },
  { map = '<leader>sb',      cmd = function() Snacks.picker.lines() end,                                                      desc = 'Buffer Lines', },
  { map = '<leader>sd',      cmd = function() Snacks.picker.diagnostics() end,                                                desc = 'Diagnostics', },
  { map = '<leader>sh',      cmd = function() Snacks.picker.help() end,                                                       desc = 'Help Pages', },
  { map = '<leader>sk',      cmd = function() Snacks.picker.keymaps() end,                                                    desc = 'Keymaps', },

  -- LSP operations
  { map = 'gd',              cmd = function() Snacks.picker.lsp_definitions() end,                                            desc = 'Goto Definition', },
  { map = 'gD',              cmd = function() Snacks.picker.lsp_declarations() end,                                           desc = 'Goto Declaration', },
  { map = 'gR',              cmd = function() Snacks.picker.lsp_references() end,                                             desc = 'References', },
  { map = 'gI',              cmd = function() Snacks.picker.lsp_implementations() end,                                        desc = 'Goto Implementation', },
  { map = 'gy',              cmd = function() Snacks.picker.lsp_type_definitions() end,                                       desc = 'Goto T[y]pe Definition', },
  { map = '<leader>ss',      cmd = function() Snacks.picker.lsp_symbols() end,                                                desc = 'LSP Symbols', },

  -- Notifications
  { map = '<leader>n',       cmd = function() Snacks.notifier.show_history() end,                                             desc = 'Notification History', },
  { map = '<leader>un',      cmd = function() Snacks.notifier.hide() end,                                                     desc = 'Dismiss All Notifications', },

  -- Ufo
  { map = 'zR',              cmd = function() require('ufo').openAllFolds() end,                                              desc = 'Open all folds', },
  { map = 'zM',              cmd = function() require('ufo').closeAllFolds() end,                                             desc = 'Close all folds', },

  -- Gemini
  { map = "<leader>a/",      cmd = "<cmd>Gemini toggle<cr>",                                                                  desc = "Toggle Gemini CLI" },
  { map = "<leader>aa",      cmd = "<cmd>Gemini ask<cr>",                                                                     desc = "Ask Gemini",                      mode = { "n", "v" } },
  { map = "<leader>af",      cmd = "<cmd>Gemini add_file<cr>",                                                                desc = "Add File" },
}
