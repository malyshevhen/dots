require "nvchad.mappings"

-- Disable mappings
-- local nomap = vim.keymap.del
-- nomap({ "n", "i", "v" }, "gr")

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

map("n", "<leader>h", ":nohlsearch<CR>")

-- Diagnostic keymap
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, { desc = "[W]orkspace [S]ymbols" })
map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, { desc = "[D]ocument [S]ymbols" })
map("n", "<leader>gd", require("telescope.builtin").lsp_definitions, { desc = "[G]oto [D]efinition" })
map("n", "<leader>gr", require("telescope.builtin").lsp_references, { desc = "[G]oto [R]eferences" })
map("n", "<leader>gi", require("telescope.builtin").lsp_implementations, { desc = "[G]oto [I]mplementation" })
map("n", "<leader>D", require("telescope.builtin").lsp_type_definitions, { desc = "Type [D]efinition" })

map({ "n", "v" }, "<leader>gB", function()
  Snacks.gitbrowse()
end, { desc = "Git Browse" })
map("n", "<leader>gb", function()
  Snacks.git.blame_line()
end, { desc = "Git Blame Line" })
map("n", "<leader>gf", function()
  Snacks.lazygit.log_file()
end, { desc = "Lazygit Current File History" })
map("n", "<leader>gg", function()
  Snacks.lazygit()
end, { desc = "Lazygit" })
map("n", "<leader>gl", function()
  Snacks.lazygit.log()
end, { desc = "Lazygit Log (cwd)" })

map("n", "<leader>z", function()
  Snacks.zen()
end, { desc = "Toggle [Z]en Mode" })

map("n", "<leader>Z", function()
  Snacks.zen.zoom()
end, { desc = "Toggle [Z]oom" })

-- Move selected lines up and down
map("v", "J", ":m'>+1<CR>gv=gv", { desc = "Move selected lines up" })
map("v", "K", ":m'<-2<CR>gv=gv", { desc = "Move selected lines down" })

map("n", "\\", ":NvimTreeToggle<CR>", { desc = "Toggle NvimTree" })

local trouble = require "trouble"
local toggle = function(cmd)
  return function()
    trouble.toggle(cmd)
  end
end

map("n", "<leader>tx", toggle(), { desc = "Toggle trouble agnostic" })
map("n", "<leader>tw", toggle "workspace_diagnostics", { desc = "Toggle trouble workspace diagnostics" })
map("n", "<leader>td", toggle "document_diagnostics", { desc = "Toggle trouble document diagnostics" })
map("n", "<leader>tq", toggle "quickfix", { desc = "Toggle quickfix list" })
map("n", "<leader>tl", toggle "loclist", { desc = "Toggle loclist list" })

map("n", "<c-h>", ":TmuxNavigateLeft<cr>")
map("n", "<c-j>", ":TmuxNavigateDown<cr>")
map("n", "<c-k>", ":TmuxNavigateUp<cr>")
map("n", "<c-l>", ":TmuxNavigateRight<cr>")
map("n", "<c-\\>", ":TmuxNavigatePrevious<cr>")
