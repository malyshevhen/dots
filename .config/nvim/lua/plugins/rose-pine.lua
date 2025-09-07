P:add('https://github.com/rose-pine/neovim', 'rose-pine', {
  opts = {
    variant = 'auto',
    dark_variant = 'main',
    dim_inactive_windows = false,
    extend_background_behind_borders = false,
    styles = {
      bold = false,
      italic = false,
      transparency = false,
    },
  },

  config = function()
    vim.cmd.colorscheme 'rose-pine'
  end,
})
