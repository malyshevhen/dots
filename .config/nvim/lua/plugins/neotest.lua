return Plug.new('https://github.com/nvim-neotest/neotest', 'neotest', {
  deps = {
    'https://github.com/nvim-neotest/nvim-nio',
    'https://github.com/antoinemadec/FixCursorHold.nvim',
    'https://github.com/fredrikaverpil/neotest-golang',
    'https://github.com/jfpedroza/neotest-elixir',
    'https://github.com/nvim-neotest/neotest-python',
    'https://github.com/rcasia/neotest-java',
    'https://github.com/nvim-neotest/neotest-jest',
    'https://github.com/marilari88/neotest-vitest',
    'https://github.com/folke/trouble.nvim',
  },

  opts = {
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
  },

  config = function(opts)
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
        config = {},
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
  end,

  -- stylua: ignore
  keymaps = {
    -- Test running
    { map = '<leader>t',  cmd = '',                                                                                        desc = '+test', },
    { map = '<leader>tt', cmd = function() require('neotest').run.run(vim.fn.expand '%') end,                              desc = 'Run File (Neotest)', },
    { map = '<leader>tT', cmd = function() require('neotest').run.run(vim.uv.cwd()) end,                                   desc = 'Run All Test Files (Neotest)', },
    { map = '<leader>tr', cmd = function() require('neotest').run.run() end,                                               desc = 'Run Nearest (Neotest)', },
    { map = '<leader>tl', cmd = function() require('neotest').run.run_last() end,                                          desc = 'Run Last (Neotest)', },
    { map = '<leader>tS', cmd = function() require('neotest').run.stop() end,                                              desc = 'Stop (Neotest)', },
    { map = '<leader>ta', cmd = function() require('neotest').run.attach() end,                                            desc = 'Attach (Neotest)', },

    -- Test UI
    { map = '<leader>ts', cmd = function() require('neotest').summary.toggle() end,                                        desc = 'Toggle Summary (Neotest)', },
    { map = '<leader>to', cmd = function() require('neotest').output.open { enter = true, auto_close = true } end,         desc = 'Show Output (Neotest)', },
    { map = '<leader>tO', cmd = function() require('neotest').output_panel.toggle() end,                                   desc = 'Toggle Output Panel (Neotest)', },

    -- Test watching
    { map = '<leader>tw', cmd = function() require('neotest').watch.toggle(vim.fn.expand '%') end,                         desc = 'Toggle Watch (Neotest)', },
    { map = '<leader>tW', cmd = function() require('neotest').watch.toggle(vim.uv.cwd()) end,                              desc = 'Toggle Watch All (Neotest)', },

    -- Test debugging
    { map = '<leader>td', cmd = function() require('neotest').run.run { strategy = 'dap' } end,                            desc = 'Debug Nearest (Neotest)', },
    { map = '<leader>tD', cmd = function() require('neotest').run.run { vim.fn.expand '%', strategy = 'dap' } end,         desc = 'Debug File (Neotest)', },

    -- Test marks and targets
    { map = '<leader>tm', cmd = function() require('neotest').run.run { suite = false, extra_args = { '--verbose' } } end, desc = 'Run Nearest with Args (Neotest)', },
    { map = '<leader>tM', cmd = function() require('neotest').summary.run_marked() end,                                    desc = 'Run Marked Tests (Neotest)', },

    -- Navigation
    { map = ']t',         cmd = function() require('neotest').jump.next { status = 'failed' } end,                         desc = 'Next Failed Test', },
    { map = '[t',         cmd = function() require('neotest').jump.prev { status = 'failed' } end,                         desc = 'Previous Failed Test', },
  },
})
