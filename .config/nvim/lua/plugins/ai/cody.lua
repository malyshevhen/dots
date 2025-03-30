local M = { 'sourcegraph/sg.nvim' }
M.lazy = false
M.dependencies = { 'nvim-lua/plenary.nvim' }
M.config = function()
  local sg = require 'sg'
  sg.setup {
    -- definition = 'gd',
    -- references = 'gr',
    -- hover = 'K',
    -- rename = 'gR',
    -- implementation = 'gi',
    -- typeDefinition = 'gT',
  }
end

-- stylua: ignore
M.keys = {
        { '<leader>cc', '<cmd>CodyChat<cr>',    desc = 'Cody Chat' },
        { '<leader>ce', '<cmd>CodyExplain<cr>', desc = 'Cody Chat' },
}

return M
