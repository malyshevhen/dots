P:add('https://github.com/Saghen/blink.cmp', 'blink.cmp', {
  opts = {
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
  },
  version = 'v1.6.0',
})
