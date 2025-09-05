local Plug = require('types').Plug

return Plug.new('https://github.com/echasnovski/mini.nvim', 'mini.nvim', {
  config = function()
    local mini_modules = {
      'pairs',
      'surround',
      'ai',
      'move',
      'operators',
      'comment',
      'jump',
      'icons',
    }

    for _, module in ipairs(mini_modules) do
      require('mini.' .. module).setup()
    end
  end,
})
