local M = { 'VidocqH/lsp-lens.nvim' }

M.config = function()
  local SymbolKind = vim.lsp.protocol.SymbolKind

  require('lsp-lens').setup {
    enable = true,
    include_declaration = false, -- Reference include declaration
    sections = {
      definition = function(count)
        return 'Definitions: ' .. count
      end,
      references = function(count)
        return 'References: ' .. count
      end,
      implements = function(count)
        return 'Implements: ' .. count
      end,
      git_authors = function(latest_author, count)
        return ' ' .. latest_author .. (count - 1 == 0 and '' or (' + ' .. count - 1))
      end,
    },

    ignore_filetype = { 'prisma' },

    -- Target Symbol Kinds to show lens information
    target_symbol_kinds = { SymbolKind.Function, SymbolKind.Method, SymbolKind.Interface },
    -- Symbol Kinds that may have target symbol kinds as children
    wrapper_symbol_kinds = { SymbolKind.Class, SymbolKind.Struct },
  }
end

return M
