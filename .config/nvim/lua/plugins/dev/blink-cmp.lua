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

  sources = {
    default = { 'lsp', 'path', 'buffer', 'snippets' },
  },

  completion = {
    documentation = {
      auto_show = false,
    },

    list = {
      max_items = 200,

      selection = {
        preselect = false,
        auto_insert = false,
      },

      cycle = {
        from_bottom = false,
        from_top = false,
      },
    },
  },

  signature = {
    enabled = true,
  },

  fuzzy = { implementation = 'prefer_rust_with_warning' },
}

M.opts_extend = { 'sources.default' }

return M
