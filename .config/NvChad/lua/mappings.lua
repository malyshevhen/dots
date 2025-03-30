-- require "nvchad.mappings"

-- Disable mappings
-- local nomap = vim.keymap.del
-- nomap({ "n", "i", "v" }, "<Leader>e")

-- add yours here
local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Yank and paste from system clipboard
map("v", "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("v", "<leader>Y", '"+Y', { desc = "Yank to clipboard" })
map("v", "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("v", "<leader>P", '"+P', { desc = "Paste from clipboard" })

--  See `:help wincmd` for a list of all window commands
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

map("n", "<c-h>", ":TmuxNavigateLeft<cr>")
map("n", "<c-j>", ":TmuxNavigateDown<cr>")
map("n", "<c-k>", ":TmuxNavigateUp<cr>")
map("n", "<c-l>", ":TmuxNavigateRight<cr>")
map("n", "<c-\\>", ":TmuxNavigatePrevious<cr>")

map("n", "<C-h>", ":nohlsearch<CR>")

-- map("n", "\\", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

-- LSP
map("n", '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[n]ame' })
map("n", '<leader>cf', vim.lsp.buf.format, { desc = '[C]ode [F]ormat' })
map("n", '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
map("n", 'gD', vim.lsp.buf.declaration, { desc = '[G]oto [D]eclaration' })
