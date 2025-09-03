local M = { 'windwp/nvim-autopairs' }

M.event = 'InsertEnter'
M.config = true

M.config = function()
  local npairs = require 'nvim-autopairs'
  npairs.setup()
end

return M
