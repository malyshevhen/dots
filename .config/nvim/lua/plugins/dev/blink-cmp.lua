local M = { 'saghen/blink.cmp' }

M.dependencies = {
  'rafamadriz/friendly-snippets',
}

M.version = '1.*'

---@module 'blink.cmp'
---@type blink.cmp.Config
M.opts = {
  keymap = { preset = 'enter' },

  appearance = {
    nerd_font_variant = 'mono',
  },

  completion = { documentation = { auto_show = false } },

  signature = { enabled = true },

  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

M.opts_extend = { 'sources.default' }

return M
