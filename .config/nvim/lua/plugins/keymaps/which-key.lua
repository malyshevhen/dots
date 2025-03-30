local M = { 'folke/which-key.nvim' }

M.event = 'VimEnter' -- Sets the loading event to 'VimEnter'

M.config = function() -- This is the function that runs, AFTER loading
  local wk = require 'which-key'
  wk.setup {}

  -- Document existing key chains
  wk.add {
    { '<leader>c', group = '[C]ode' },
    { '<leader>d', group = '[D]ocument' },
    { '<leader>r', group = '[R]ename' },
    { '<leader>s', group = '[S]earch' },
    { '<leader>w', group = '[W]orkspace' },
    { '<leader>t', group = '[T]oggle' },
  }
end

return M
