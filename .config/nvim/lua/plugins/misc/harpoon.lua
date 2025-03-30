local M = { 'ThePrimeagen/harpoon' }

M.branch = 'harpoon2'

M.opts = {
  menu = {
    width = vim.api.nvim_win_get_width(0) - 4,
  },
  settings = {
    save_on_toggle = true,
  },
}

-- stylua: ignore
M.keys = {
        { '<leader>H', function() require('harpoon'):list():add() end,                                    desc = 'Harpoon File' },
        { '<leader>h', function() require('harpoon').ui:toggle_quick_menu(require('harpoon'):list()) end, desc = 'Harpoon Quick Menu' },
        { '<leader>1', function() require('harpoon'):list():select(1) end,                                desc = 'Harpoon to File 1' },
        { '<leader>2', function() require('harpoon'):list():select(2) end,                                desc = 'Harpoon to File 2' },
        { '<leader>3', function() require('harpoon'):list():select(3) end,                                desc = 'Harpoon to File 3' },
        { '<leader>4', function() require('harpoon'):list():select(4) end,                                desc = 'Harpoon to File 4' },
        { '<leader>5', function() require('harpoon'):list():select(5) end,                                desc = 'Harpoon to File 5' },
}

return M
