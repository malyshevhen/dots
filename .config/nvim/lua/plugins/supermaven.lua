local Plug = require('types').Plug

return Plug.new('https://github.com/supermaven-inc/supermaven-nvim', 'supermaven-nvim', {
  deps = { 'https://github.com/onsails/lspkind.nvim' },
  opts = {
    keymaps = {
      accept_suggestion = '<Tab>',
      clear_suggestion = '<C-h>',
      accept_word = '<C-l>',
    },
    ignore_filetypes = {
      cpp = true,
      c = true,
      markdown = false,
      text = false,
    },
    color = {
      suggestion_color = '#808080',
      cterm = 244,
    },
    log_level = 'off',
    disable_inline_completion = false,
    disable_keymaps = false,
    condition = function()
      -- Disable in certain contexts
      local buftype = vim.bo.buftype
      local filetype = vim.bo.filetype

      -- Disable in terminal, help, and other special buffers
      if buftype ~= '' and buftype ~= 'acwrite' then
        return true
      end

      -- Disable in certain filetypes
      local disabled_filetypes = {
        'help',
        'gitcommit',
        'gitrebase',
        'TelescopePrompt',
        'alpha',
      }

      return vim.tbl_contains(disabled_filetypes, filetype)
    end,
  },
  config = function()
    -- Configure lspkind integration
    local ok_lspkind, lspkind = pcall(require, 'lspkind')
    if ok_lspkind then
      lspkind.init {
        symbol_map = {
          Supermaven = '',
        },
      }
    end

    -- Set highlight for Supermaven completions
    vim.api.nvim_set_hl(0, 'CmpItemKindSupermaven', { fg = '#6CC644' })

    -- Optional: Add custom autocmds for better integration
    vim.api.nvim_create_autocmd('InsertEnter', {
      pattern = '*',
      callback = function()
        -- Ensure supermaven is active in insert mode
        local supermaven = require 'supermaven-nvim'
        if supermaven and supermaven.is_running and not supermaven.is_running() then
          supermaven.start()
        end
      end,
    })
  end,
  keymaps = {
    {
      map = '<leader>as',
      cmd = function()
        local supermaven = require 'supermaven-nvim'
        if supermaven.is_running() then
          supermaven.stop()
          vim.notify('Supermaven stopped', vim.log.levels.INFO)
        else
          supermaven.start()
          vim.notify('Supermaven started', vim.log.levels.INFO)
        end
      end,
      desc = 'Toggle Supermaven',
    },
    {
      map = '<leader>ar',
      cmd = function()
        require('supermaven-nvim').restart()
        vim.notify('Supermaven restarted', vim.log.levels.INFO)
      end,
      desc = 'Restart Supermaven',
    },
  },
})
