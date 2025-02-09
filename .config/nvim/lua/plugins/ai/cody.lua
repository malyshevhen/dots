return {
  'sourcegraph/sg.nvim',
  lazy = false,
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local sg = require 'sg'
    sg.setup {
      -- definition = 'gd',
      -- references = 'gr',
      -- hover = 'K',
      -- rename = 'gR',
      -- implementation = 'gi',
      -- typeDefinition = 'gT',
    }
  end,
  keys = {
    { '<leader>cc', '<cmd>CodyChat<cr>', desc = 'Cody Chat' },
    { '<leader>ce', '<cmd>CodyExplain<cr>', desc = 'Cody Chat' },
  },
}
