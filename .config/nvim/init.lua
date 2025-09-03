--- Options
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.signcolumn = "yes"
vim.cmd("set expandtab")
vim.cmd("set completeopt=noselect")

vim.opt.winborder = "rounded"

vim.api.nvim_set_option_value("clipboard", "unnamed", {})

-- set faster completion
vim.opt.updatetime = 60

-- disable backup file creation
vim.opt.backup = false
-- prevent editing of files being edited elsewhere
vim.opt.writebackup = false

-- Removes tilde symbols from the end of the page
vim.opt.fillchars = { eob = " " }

vim.opt.swapfile = false

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.scrolloff = 10

-- Nerd Fonts
vim.g.have_nerd_font = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Disable line wraps
vim.opt.wrap = false

--- Autocmds
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("Highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

--- Indentation
vim.cmd("filetype plugin indent on")

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "javascript", "typescript", "json", "yaml" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "python" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.tabstop = 4
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "go" },
	callback = function()
		vim.bo.expandtab = false
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.tabstop = 4
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "make" },
	callback = function()
		vim.bo.expandtab = false
		vim.bo.shiftwidth = 8
		vim.bo.tabstop = 8
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sh" },
	callback = function()
		vim.bo.expandtab = false
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "sql" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 4
		vim.bo.softtabstop = 4
		vim.bo.tabstop = 4
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gleam" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "raml" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "elixir" },
	callback = function()
		vim.bo.expandtab = true
		vim.bo.shiftwidth = 2
		vim.bo.softtabstop = 2
		vim.bo.tabstop = 2
	end,
})

vim.filetype.add({
	pattern = {
		["docker-compose%.yml"] = "yaml.docker-compose",
		["docker-compose%.yaml"] = "yaml.docker-compose",
		["compose%.yml"] = "yaml.docker-compose",
		["compose%.yaml"] = "yaml.docker-compose",
		["*.raml"] = "raml",
	},
})

--- Plugins
--- Add
vim.pack.add({
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/L3MON4D3/LuaSnip" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/sschleemilch/slimline.nvim" },
	{ src = "https://github.com/thesimonho/kanagawa-paper.nvim" },
	{ src = "https://github.com/rose-pine/neovim" },
	{ src = "https://github.com/windwp/nvim-autopairs" },
	{ src = "https://github.com/supermaven-inc/supermaven-nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/onsails/lspkind.nvim" },
	{ src = "https://github.com/RRethy/nvim-treesitter-endwise" },
	{ src = "https://github.com/lewis6991/gitsigns.nvim" },
	{ src = "https://github.com/tummetott/unimpaired.nvim" },
	{ src = "https://github.com/kevinhwang91/nvim-ufo" },
	{ src = "https://github.com/kevinhwang91/promise-async" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/sindrets/diffview.nvim" },
	{ src = "https://github.com/rmagatti/auto-session" },
	{ src = "https://github.com/folke/snacks.nvim" },
	{ src = "https://github.com/goolord/alpha-nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

--- Init

-- Alpha
require("alpha").setup(require("alpha.themes.dashboard").config)

-- Mason
require("mason").setup()

-- Slimline
require("slimline").setup({ style = "fg" })

-- Autopairs
require("nvim-autopairs").setup({ map_cr = true })

-- Treesitter
local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
ts_update()

local treesitter_config = require("nvim-treesitter.configs")
treesitter_config.setup({
	ensure_installed = {
		"c",
		"lua",
		"vim",
		"vimdoc",
		"query",
		"elixir",
		"heex",
		"javascript",
		"html",
		"go",
		"gomod",
		"gosum",
		"git_config",
		"gitcommit",
		"git_rebase",
		"gitignore",
		"diff",
		"zig",
		"markdown",
		"python",
	},
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
	auto_install = true,
})

-- Theme
require("rose-pine").setup({
	-- options for the rose-pine theme
	variant = "auto", -- auto, main, moon, or dawn
	dark_variant = "main", -- main, moon, or dawn
	dim_inactive_windows = false,
	extend_background_behind_borders = false,
	styles = {
		bold = false,
		italic = false,
		transparency = false,
	},
})
vim.cmd.colorscheme("rose-pine")

-- Conform
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua", lsp_format = "fallback" },
		-- Conform will run multiple formatters sequentially
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		-- Conform will run multiple formatters sequentially
		go = { "goimports", "gofmt" },
		-- Java
		java = { "google-java-format" },
		-- Bash
		sh = { "shfmt" },
		-- SQL
		-- sql = { 'sleek' },
		-- Gleam
		gleam = { "gleam format", lsp_format = "fallback" },
		-- Elixir
		elixir = { "mix format", lsp_format = "fallback" },
		-- Python
		python = { "ruff_format", "ruff_fix", "ruff_imports", lsp_format = "fallback" },
	},
})

-- vim.api.nvim_create_user_command('CopyRelPath', "call setreg('+', expand('%'))", {})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

-- Supermaven
require("supermaven-nvim").setup({
	keymaps = {
		accept_suggestion = "<Tab>",
		clear_suggestion = "<C-h>",
		accept_word = "<C-l>",
	},
	ignore_filetypes = { cpp = true }, -- or { "cpp", }
	color = {
		suggestion_color = "#000508",
		cterm = 244,
	},
	log_level = "off", -- set to "off" to disable logging completely
	disable_inline_completion = false, -- disables inline completion for use with cmp
	disable_keymaps = false, -- disables built in keymaps for more manual control
	condition = function()
		return false
	end, -- condition to check for stopping supermaven, `true` means to stop supermaven when the condition is true.
})

require("lspkind").init({
	symbol_map = {
		Supermaven = "",
	},
})

vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#6CC644" })

-- Gitsigns
require("gitsigns").setup({
	signs = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged = {
		add = { text = "┃" },
		change = { text = "┃" },
		delete = { text = "_" },
		topdelete = { text = "‾" },
		changedelete = { text = "~" },
		untracked = { text = "┆" },
	},
	signs_staged_enable = true,
	signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
	numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
	linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
	word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
	watch_gitdir = {
		follow_files = true,
	},
	auto_attach = true,
	attach_to_untracked = false,
	current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
	current_line_blame_opts = {
		virt_text = true,
		virt_text_pos = "right_align", -- 'eol' | 'overlay' | 'right_align'
		delay = 500,
		ignore_whitespace = false,
		virt_text_priority = 100,
		use_focus = true,
	},
	current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
	sign_priority = 6,
	update_debounce = 100,
	status_formatter = nil, -- Use default
	max_file_length = 40000, -- Disable if file is longer than this (in lines)
	preview_config = {
		-- Options passed to nvim_open_win
		border = "single",
		style = "minimal",
		relative = "cursor",
		row = 0,
		col = 1,
	},

	on_attach = function(buffer)
		local git_signs = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = buffer
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]c", bang = true })
			else
				git_signs.nav_hunk("next")
			end
		end, { desc = "Navigate To Next Hunk" })

		map("n", "[c", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[c", bang = true })
			else
				git_signs.nav_hunk("prev")
			end
		end, { desc = "Navigate To Previous Hunk" })

		-- Actions
		map("n", "<leader>gs", git_signs.stage_hunk, { desc = "Stage Hunk" })
		map("n", "<leader>gr", git_signs.reset_hunk, { desc = "Reset Hunk" })

		map("v", "<leader>gs", function()
			git_signs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Stage Hunk" })

		map("v", "<leader>gr", function()
			git_signs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "Reset Hunk" })

		map("n", "<leader>gS", git_signs.stage_buffer, { desc = "Stage Buffer" })
		map("n", "<leader>gR", git_signs.reset_buffer, { desc = "Reset Buffer" })
		map("n", "<leader>gp", git_signs.preview_hunk, { desc = "Preview Hunk" })
		map("n", "<leader>gi", git_signs.preview_hunk_inline, { desc = "Preview Hunk Inline" })

		map("n", "<leader>hb", function()
			gitsigns.blame_line({ full = true })
		end, { desc = "Blame Line" })

		map("n", "<leader>gd", git_signs.diffthis, { desc = "Diff This File" })
		map("n", "<leader>gD", function()
			git_signs.diffthis("~")
		end, { desc = "Diff This File (cached)" })
		map("n", "<leader>gQ", function()
			git_signs.setqflist("all")
		end, { desc = "Set QuickFix List To All Hunks" })
		map("n", "<leader>gq", git_signs.setqflist, { desc = "Set QuickFix List To Current Hunks" })

		-- Toggles
		map("n", "<leader>tb", git_signs.toggle_current_line_blame, { desc = "Toggle Current Line Blame" })
		map("n", "<leader>td", git_signs.toggle_deleted, { desc = "Toggle Deleted" })
		map("n", "<leader>tw", git_signs.toggle_word_diff, { desc = "Toggle Word Diff" })

		-- Text object
		map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Select hunk" })
	end,
})

-- Unimpaired
require("unimpaired").setup()

-- Ufo
vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true

require("ufo").setup({
	provider_selector = function(bufnr, filetype, buftype)
		return { "treesitter", "indent" }
	end,
})

vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)

-- Mini
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.ai").setup()
require("mini.move").setup()
require("mini.operators").setup()
require("mini.comment").setup()
require("mini.jump").setup()
require("mini.icons").setup()

-- Diffview
require("diffview").setup()

vim.keymap.set("n", "<leader>gD", "<cmd>DiffviewOpen<cr>", { desc = "Open Git Diff View" })
vim.keymap.set("n", "<leader>gC", "<cmd>DiffviewClose<cr>", { desc = "Close Git Diff View" })

-- Auto-session
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
	auto_restore = false,
	auto_restore_last_session = false,
})

vim.keymap.set("n", "<leader>wr", "<cmd>SessionSearch<CR>", { desc = "Session search" })
vim.keymap.set("n", "<leader>ww", "<cmd>SessionSave<CR>", { desc = "Save session" })
vim.keymap.set("n", "<leader>wa", "<cmd>SessionToggleAutoSave<CR>", { desc = "Toggle autosave" })

-- Snacks
require("snacks").setup({
	quickfile = { enabled = true },
	picker = { enabled = true },
})

local Snacks = Snacks

vim.api.nvim_create_autocmd("User", {
	pattern = "VeryLazy",
	callback = function()
		-- Setup some globals for debugging (lazy-loaded)
		_G.dd = function(...)
			Snacks.debug.inspect(...)
		end
		_G.bt = function()
			Snacks.debug.backtrace()
		end
		vim.print = _G.dd -- Override print to use snacks for `:=` command

		-- Create some toggle mappings
		Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
		Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
		Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
		Snacks.toggle.diagnostics():map("<leader>ud")
		Snacks.toggle.line_number():map("<leader>ul")
		Snacks.toggle
			.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
			:map("<leader>uc")
		Snacks.toggle.treesitter():map("<leader>uT")
		Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map("<leader>ub")
		Snacks.toggle.inlay_hints():map("<leader>uh")
		Snacks.toggle.indent():map("<leader>ug")
		Snacks.toggle.dim():map("<leader>uD")
	end,
})

-- stylua: ignore
local keys = {
  { '<leader>z',       function() Snacks.zen() end,                                          desc = 'Toggle Zen Mode' },
  { '<leader>Z',       function() Snacks.zen.zoom() end,                                     desc = 'Toggle Zoom' },
  { '<leader>.',       function() Snacks.scratch() end,                                      desc = 'Toggle Scratch Buffer' },
  { '<leader>S',       function() Snacks.scratch.select() end,                               desc = 'Select Scratch Buffer' },
  { '<leader>n',       function() Snacks.notifier.show_history() end,                        desc = 'Notification History' },
  { '<leader>bd',      function() Snacks.bufdelete() end,                                    desc = 'Delete Buffer' },
  { '<leader>cR',      function() Snacks.rename.rename_file() end,                           desc = 'Rename File' },
  { '<leader>gB',      function() Snacks.gitbrowse() end,                                    desc = 'Git Browse',                  mode = { 'n', 'v' } },
  { '<leader>gb',      function() Snacks.git.blame_line() end,                               desc = 'Git Blame Line' },
  { '<leader>gf',      function() Snacks.lazygit.log_file() end,                             desc = 'Lazygit Current File History' },
  { '<leader>gg',      function() Snacks.lazygit() end,                                      desc = 'Lazygit' },
  { '<leader>gl',      function() Snacks.lazygit.log() end,                                  desc = 'Lazygit Log (cwd)' },
  { '<leader>un',      function() Snacks.notifier.hide() end,                                desc = 'Dismiss All Notifications' },
  -- { '<c-/>',           function() Snacks.terminal() end,                                     desc = 'Toggle Terminal' },
  -- { '<c-_>',           function() Snacks.terminal() end,                                     desc = 'which_key_ignore' },
  { ']]',              function() Snacks.words.jump(vim.v.count1) end,                       desc = 'Next Reference',              mode = { 'n', 't' } },
  { '[[',              function() Snacks.words.jump(-vim.v.count1) end,                      desc = 'Prev Reference',              mode = { 'n', 't' } },

  -- Top Pickers & Explorer
  { '<leader><space>', function() Snacks.picker.smart() end,                                 desc = 'Smart Find Files' },
  { '<leader>,',       function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
  { '<leader>/',       function() Snacks.picker.grep() end,                                  desc = 'Grep' },
  { '<leader>:',       function() Snacks.picker.command_history() end,                       desc = 'Command History' },
  { '<leader>n',       function() Snacks.picker.notifications() end,                         desc = 'Notification History' },
  { '\\',              function() Snacks.explorer() end,                                     desc = 'File Explorer' },
  { '<leader>e',       function() Snacks.explorer.reveal() end,                              desc = 'File Explorer' },

  -- find
  { '<leader>fb',      function() Snacks.picker.buffers() end,                               desc = 'Buffers' },
  { '<leader>fc',      function() Snacks.picker.files { cwd = vim.fn.stdpath 'config' } end, desc = 'Find Config File' },
  { '<leader>ff',      function() Snacks.picker.files() end,                                 desc = 'Find Files' },
  { '<leader>fg',      function() Snacks.picker.git_files() end,                             desc = 'Find Git Files' },
  { '<leader>fp',      function() Snacks.picker.projects() end,                              desc = 'Projects' },
  { '<leader>fr',      function() Snacks.picker.recent() end,                                desc = 'Recent' },

  -- git
  { '<leader>gb',      function() Snacks.picker.git_branches() end,                          desc = 'Git Branches' },
  { '<leader>gl',      function() Snacks.picker.git_log() end,                               desc = 'Git Log' },
  { '<leader>gL',      function() Snacks.picker.git_log_line() end,                          desc = 'Git Log Line' },
  { '<leader>gs',      function() Snacks.picker.git_status() end,                            desc = 'Git Status' },
  { '<leader>gS',      function() Snacks.picker.git_stash() end,                             desc = 'Git Stash' },
  { '<leader>gd',      function() Snacks.picker.git_diff() end,                              desc = 'Git Diff (Hunks)' },
  { '<leader>gf',      function() Snacks.picker.git_log_file() end,                          desc = 'Git Log File' },

  -- Grep
  { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
  { '<leader>sB',      function() Snacks.picker.grep_buffers() end,                          desc = 'Grep Open Buffers' },
  { '<leader>sg',      function() Snacks.picker.grep() end,                                  desc = 'Grep' },
  { '<leader>sw',      function() Snacks.picker.grep_word() end,                             desc = 'Visual selection or word',    mode = { 'n', 'x' } },

  -- search
  { '<leader>s"',      function() Snacks.picker.registers() end,                             desc = 'Registers' },
  { '<leader>s/',      function() Snacks.picker.search_history() end,                        desc = 'Search History' },
  { '<leader>sa',      function() Snacks.picker.autocmds() end,                              desc = 'Autocmds' },
  { '<leader>sb',      function() Snacks.picker.lines() end,                                 desc = 'Buffer Lines' },
  { '<leader>sc',      function() Snacks.picker.command_history() end,                       desc = 'Command History' },
  { '<leader>sC',      function() Snacks.picker.commands() end,                              desc = 'Commands' },
  { '<leader>sd',      function() Snacks.picker.diagnostics() end,                           desc = 'Diagnostics' },
  { '<leader>sD',      function() Snacks.picker.diagnostics_buffer() end,                    desc = 'Buffer Diagnostics' },
  { '<leader>sh',      function() Snacks.picker.help() end,                                  desc = 'Help Pages' },
  { '<leader>sH',      function() Snacks.picker.highlights() end,                            desc = 'Highlights' },
  { '<leader>si',      function() Snacks.picker.icons() end,                                 desc = 'Icons' },
  { '<leader>sj',      function() Snacks.picker.jumps() end,                                 desc = 'Jumps' },
  { '<leader>sk',      function() Snacks.picker.keymaps() end,                               desc = 'Keymaps' },
  { '<leader>sl',      function() Snacks.picker.loclist() end,                               desc = 'Location List' },
  { '<leader>sm',      function() Snacks.picker.marks() end,                                 desc = 'Marks' },
  { '<leader>sM',      function() Snacks.picker.man() end,                                   desc = 'Man Pages' },
  { '<leader>sp',      function() Snacks.picker.lazy() end,                                  desc = 'Search for Plugin Spec' },
  { '<leader>sq',      function() Snacks.picker.qflist() end,                                desc = 'Quickfix List' },
  { '<leader>sR',      function() Snacks.picker.resume() end,                                desc = 'Resume' },
  { '<leader>su',      function() Snacks.picker.undo() end,                                  desc = 'Undo History' },
  { '<leader>uC',      function() Snacks.picker.colorschemes() end,                          desc = 'Colorschemes' },

  -- LSP
  { 'gd',              function() Snacks.picker.lsp_definitions() end,                       desc = 'Goto Definition' },
  { 'gD',              function() Snacks.picker.lsp_declarations() end,                      desc = 'Goto Declaration' },
  { 'gR',              function() Snacks.picker.lsp_references() end,                        desc = 'References',                  nowait = true },
  { 'gI',              function() Snacks.picker.lsp_implementations() end,                   desc = 'Goto Implementation' },
  { 'gy',              function() Snacks.picker.lsp_type_definitions() end,                  desc = 'Goto T[y]pe Definition' },
  { '<leader>ss',      function() Snacks.picker.lsp_symbols() end,                           desc = 'LSP Symbols' },
  { '<leader>sS',      function() Snacks.picker.lsp_workspace_symbols() end,                 desc = 'LSP Workspace Symbols' },
}

for _, key in ipairs(keys) do
	vim.keymap.set(key.mode or "n", key[1], key[2], { desc = key.desc })
end

--- LSP
vim.lsp.enable({
	"lua_ls",
	"ruff",
	"gopls",
})

vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
			vim.opt.completeopt = { "menu", "menuone", "noinsert", "fuzzy", "popup" }
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
			vim.keymap.set("i", "<C-Space>", function()
				vim.lsp.completion.get()
			end)
		end
	end,
})

--- Diagnostics
vim.diagnostic.config({
	-- Use the default configuration
	-- virtual_lines = true

	-- Alternatively, customize specific options
	virtual_lines = {
		-- Only show virtual line diagnostics for the current cursor line
		current_line = true,
	},
})

--- Keymaps
local map = vim.keymap.set

-- Yank and paste from system clipboard
map("v", "<leader>y", '"+y')
map("v", "<leader>Y", '"+Y')
map("v", "<leader>p", '"+p')
map("v", "<leader>P", '"+P')

-- Diagnostics
map("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic [E]rror messages" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

-- Navigate vim panes better
map("n", "<c-k>", ":wincmd k<CR>")
map("n", "<c-j>", ":wincmd j<CR>")
map("n", "<c-h>", ":wincmd h<CR>")
map("n", "<c-l>", ":wincmd l<CR>")

map("n", "<leader>o", ":update<CR> :source<CR>")
map({ "n", "v", "x" }, "<leader>cf", require("conform").format)
