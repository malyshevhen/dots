local M = { 'saecki/crates.nvim' }

M.ft = { 'rust', 'toml' }

M.config = function(_, opts)
  local crates = require 'crates'
  crates.setup(opts)
  crates.show()
end

return M
