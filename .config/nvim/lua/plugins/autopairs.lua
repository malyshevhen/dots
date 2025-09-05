local Plug = require('types').Plug

return Plug.new('https://github.com/windwp/nvim-autopairs', 'nvim-autopairs', {
  opts = { map_cr = true },
})
