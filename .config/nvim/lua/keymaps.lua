-- stylua: ignore
---@type Keymaps
local global_key_mappings = {
  --- Yank and paste from system clipboard
  { map = '<leader>y',  cmd = '"+y',                                                                              desc = 'Yank (Clipboard)',             mode = { "v", "x" } },
  { map = '<leader>Y',  cmd = '"+Y',                                                                              desc = 'Yank (Clipboard)',             mode = { "v", "x" } },
  { map = '<leader>p',  cmd = '"+p',                                                                              desc = 'Paste (Clipboard)',            mode = { "v", "x" } },
  { map = '<leader>P',  cmd = '"+P',                                                                              desc = 'Paste (Clipboard)',            mode = { "v", "x" } },

  --- Navigate vim panes better
  { map = '<c-k>',      cmd = ':wincmd k<CR>',                                                                    desc = 'Move to top pane' },
  { map = '<c-j>',      cmd = ':wincmd j<CR>',                                                                    desc = 'Move to bottom pane' },
  { map = '<c-h>',      cmd = ':wincmd h<CR>',                                                                    desc = 'Move to left pane' },
  { map = '<c-l>',      cmd = ':wincmd l<CR>',                                                                    desc = 'Move to right pane' },
  { map = '<leader>o',  cmd = ':update<CR> :source<CR>' },

  --- Neotest -- Begin
  { map = "<leader>t",  cmd = "",                                                                                 desc = "+test" },
  { map = "<leader>tt", cmd = function() require("neotest").run.run(vim.fn.expand("%")) end,                      desc = "Run File (Neotest)" },
  { map = "<leader>tT", cmd = function() require("neotest").run.run(vim.uv.cwd()) end,                            desc = "Run All Test Files (Neotest)" },
  { map = "<leader>tr", cmd = function() require("neotest").run.run() end,                                        desc = "Run Nearest (Neotest)" },
  { map = "<leader>tl", cmd = function() require("neotest").run.run_last() end,                                   desc = "Run Last (Neotest)" },
  { map = "<leader>ts", cmd = function() require("neotest").summary.toggle() end,                                 desc = "Toggle Summary (Neotest)" },
  { map = "<leader>to", cmd = function() require("neotest").output.open({ enter = true, auto_close = true }) end, desc = "Show Output (Neotest)" },
  { map = "<leader>tO", cmd = function() require("neotest").output_panel.toggle() end,                            desc = "Toggle Output Panel (Neotest)" },
  { map = "<leader>tS", cmd = function() require("neotest").run.stop() end,                                       desc = "Stop (Neotest)" },
  { map = "<leader>tw", cmd = function() require("neotest").watch.toggle(vim.fn.expand("%")) end,                 desc = "Toggle Watch (Neotest)" },
  --- Neotest -- End

  --- LSP -- Begin
  { map = 'gD',         cmd = vim.lsp.buf.declaration,                                                            desc = '[G]oto [D]eclaration',         mode = { 'n' } },
  { map = '<leader>cr', cmd = vim.lsp.buf.rename,                                                                 desc = '[C]ode [R]ename',              mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action,                                                            desc = '[C]ode [A]ction',              mode = { 'n', 'v' } },
  --- LSP -- End
}

--- Check for conflicts
---@param mappings Keymaps
---@return nil
local check_conflicts = function(mappings)
  ---@type string[]
  local keys = {}

  for _, mapping in ipairs(mappings) do
    local key = mapping.map
    if not vim.tbl_contains(keys, key) then
      keys[#keys + 1] = key
    else
      vim.notify('Conflicting key mappings: ' .. key)
    end
  end
end

--- Set key mappings
---@param mappings Keymaps
---@return nil
local set_keymap = function(mappings)
  for _, key in ipairs(mappings) do
    vim.keymap.set(key.mode or 'n', key.map, key.cmd, { desc = key.desc })
  end
end

check_conflicts(global_key_mappings)
set_keymap(global_key_mappings)
