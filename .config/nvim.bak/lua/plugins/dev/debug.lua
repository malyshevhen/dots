local M = {
  'mfussenegger/nvim-dap',
}

M.dependencies = {
  'rcarriga/nvim-dap-ui', -- Creates a beautiful debugger UI
  'nvim-neotest/nvim-nio', -- Required dependency for nvim-dap-ui
  'williamboman/mason.nvim', -- Installs the debug adapters for you
  'jay-babu/mason-nvim-dap.nvim',
  'leoluz/nvim-dap-go',
}

M.config = function()
  require('mason-nvim-dap').setup {
    automatic_installation = true,
    handlers = {},
    ensure_installed = {
      'delve',
    },
  }

  local dap_ui = require 'dapui'

  dap_ui.setup {
    icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
    controls = {
      icons = {
        pause = '⏸',
        play = '▶',
        step_into = '⏎',
        step_over = '⏭',
        step_out = '⏮',
        step_back = 'b',
        run_last = '▶▶',
        terminate = '⏹',
        disconnect = '⏏',
      },
    },
  }

  -- vim.keymap.set('n', '<F7>', dapui.toggle, { desc = 'Debug: See last session result.' })
  local dap = require 'dap'

  dap.listeners.after.event_initialized['dapui_config'] = dap_ui.open
  dap.listeners.before.event_terminated['dapui_config'] = dap_ui.close
  dap.listeners.before.event_exited['dapui_config'] = dap_ui.close

  require('dap-go').setup {
    delve = {
      detached = vim.fn.has 'win32' == 0,
    },
  }

  -- vim.keymap.set('n', '<F5>', require('dap').continue, { desc = 'Debug: Start/Continue' })
  -- vim.keymap.set('n', '<F1>', require('dap').step_into, { desc = 'Debug: Step Into' })
  -- vim.keymap.set('n', '<F2>', require('dap').step_over, { desc = 'Debug: Step Over' })
  -- vim.keymap.set('n', '<F3>', require('dap').step_out, { desc = 'Debug: Step Out' })
  -- vim.keymap.set('n', '<leader>b', require('dap').toggle_breakpoint, { desc = 'Debug: Toggle Breakpoint' })
  -- vim.keymap.set('n', '<leader>B', function()
  --   require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
  -- end, { desc = 'Debug: Set Breakpoint' })
end

-- stylua: ignore
M.keys = function()
  return {
    { '<F5>',      require('dap').continue,                                                             { desc = 'Debug: Start/Continue' } },
    { '<F1>',      require('dap').step_into,                                                            { desc = 'Debug: Step Into' } },
    { '<F2>',      require('dap').step_over,                                                            { desc = 'Debug: Step Over' } },
    { '<F3>',      require('dap').step_out,                                                             { desc = 'Debug: Step Out' } },
    { '<leader>b', require('dap').toggle_breakpoint,                                                    { desc = 'Debug: Toggle Breakpoint' } },
    { '<leader>B', function() require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ') end, { desc = 'Debug: Set Breakpoint' } },
    { '<F7>',      require('dapui').toggle,                                                             { desc = 'Debug: See last session result.' } },
  }
end

return M
