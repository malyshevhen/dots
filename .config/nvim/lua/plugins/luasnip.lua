P:add('https://github.com/L3MON4D3/LuaSnip', 'LuaSnip', {
  config = function()
    local luasnip = require 'luasnip'

    -- Basic configuration
    luasnip.config.setup {
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

    -- Load snippets from friendly-snippets if available
    local ok, friendly_snippets = pcall(require, 'luasnip.loaders.from_vscode')
    if ok then
      friendly_snippets.lazy_load()
    end
  end,
})
