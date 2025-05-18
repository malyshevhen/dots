local M = { 'windwp/nvim-autopairs' }

M.event = 'InsertEnter'
M.config = true

M.config = function()
  local npairs = require 'nvim-autopairs'
  local Rule = require 'nvim-autopairs.rule'

  npairs.setup()

  -- Add special rule for Elixir "do-end" blocks
  -- npairs.add_rules {
  --   Rule('do$', 'end', 'elixir')
  --     :use_regex(true)
  --     :replace_endpair(function()
  --       return '\n  ' .. 'end' -- Adds newline, indentation, and "end"
  --     end)
  --     :set_end_pair_length(0), -- Makes cursor position inside the block
  -- }
end

return M
