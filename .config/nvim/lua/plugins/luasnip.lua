local Plug = require('types').Plug

return Plug.new('https://github.com/L3MON4D3/LuaSnip', 'LuaSnip', {
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
  keymaps = {
    {
      map = '<Tab>',
      cmd = function()
        local luasnip = require 'luasnip'
        if luasnip.expand_or_jumpable() then
          luasnip.expand_or_jump()
        else
          return '<Tab>'
        end
      end,
      desc = 'Expand or jump to next snippet placeholder',
      mode = { 'i', 's' },
    },
    {
      map = '<S-Tab>',
      cmd = function()
        local luasnip = require 'luasnip'
        if luasnip.jumpable(-1) then
          luasnip.jump(-1)
        else
          return '<S-Tab>'
        end
      end,
      desc = 'Jump to previous snippet placeholder',
      mode = { 'i', 's' },
    },
    {
      map = '<C-e>',
      cmd = function()
        local luasnip = require 'luasnip'
        if luasnip.choice_active() then
          luasnip.change_choice(1)
        end
      end,
      desc = 'Change snippet choice',
      mode = { 'i', 's' },
    },
  },
})
