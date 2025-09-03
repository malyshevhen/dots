local M = { 'lewis6991/hover.nvim' }

M.config = function()
  require('hover').setup {
    init = function()
      -- Require providers
      require 'hover.providers.lsp'
      -- require('hover.providers.gh')
      -- require('hover.providers.gh_user')
      -- require('hover.providers.jira')
      require 'hover.providers.dap'
      require 'hover.providers.fold_preview'
      require 'hover.providers.diagnostic'
      -- require('hover.providers.man')
      -- require('hover.providers.dictionary')
    end,
    preview_opts = {
      border = 'single',
    },
    -- Whether the contents of a currently open hover window should be moved
    -- to a :h preview-window when pressing the hover keymap.
    preview_window = false,
    title = true,
    mouse_providers = {
      'LSP',
    },
    mouse_delay = 1000,
  }

  vim.o.mousemoveevent = true
end

-- stylua: ignore
M.keys = function()
  return {
    { 'K',           require('hover').hover,                                  desc = 'hover.nvim' },
    { 'gK',          require('hover').hover_select,                           desc = 'hover.nvim (select)' },
    { '<C-p>',       function() require('hover').hover_switch 'previous' end, desc = 'hover.nvim (previous source)' },
    { '<C-n>',       function() require('hover').hover_switch 'next' end,     desc = 'hover.nvim (next source)' },
    { '<MouseMove>', require('hover').hover_mouse,                            desc = 'hover.nvim (mouse)' },
  }
end

return M
