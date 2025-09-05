local Plug = require('types').Plug

return Plug.new('https://github.com/goolord/alpha-nvim', 'alpha', {
  deps = { 'https://github.com/nvim-tree/nvim-web-devicons' },
  config = function()
    require('alpha').setup(require('alpha.themes.dashboard').config)
  end,
})
