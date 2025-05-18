local M = {
  none = {},
  vscode = { 'Mofiqul/vscode.nvim' },
  gruvbox = { 'ellisonleao/gruvbox.nvim' },
  pywal = { 'AlphaTechnolog/pywal.nvim' },
  gruvbox_baby = { 'luisiacc/gruvbox-baby' },
  gruvbox_material = { 'f4z3r/gruvbox-material.nvim' },
  github = { 'projekt0n/github-nvim-theme' },
  kanagawa = { 'rebelot/kanagawa.nvim' },
}

M.vscode.config = function()
  vim.o.background = 'dark' -- For dark theme (neovim's default)
  -- vim.o.background = 'light' -- For light theme

  local c = require('vscode.colors').get_colors()
  require('vscode').setup {
    -- style = 'light' -- Alternatively set style in setup
    transparent = false, -- Enable transparent background
    italic_comments = true, -- Enable italic comment
    underline_links = true, -- Underline `@markup.link.*` variants
    disable_nvimtree_bg = true, -- Disable nvim-tree background color
    color_overrides = { vscLineNumber = '#FFFFFF' }, -- Override colors (see ./lua/vscode/colors.lua)
    float = { background_color = nil }, -- set color for float backgrounds. If nil, uses the default color set
    group_overrides = { Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true } }, -- Override highlight groups (see ./lua/vscode/theme.lua)
  }

  vim.cmd.colorscheme 'vscode'
end

M.gruvbox.lazy = false
M.gruvbox.priority = 1000
M.gruvbox.config = function()
  require('gruvbox').setup {
    terminal_colors = true, -- add neovim terminal colors
    undercurl = true,
    underline = true,
    bold = false,
    italic = {
      strings = false,
      emphasis = false,
      comments = true,
      operators = false,
      folds = false,
    },
    strikethrough = true,
    invert_selection = false,
    invert_signs = false,
    invert_tabline = false,
    invert_intend_guides = false,
    inverse = false, -- invert background for search, diffs, statuslines and errors
    contrast = 'soft', -- can be "hard", "soft" or empty string
    overrides = {},
    dim_inactive = false,
    transparent_mode = false, -- transparent background for terminals
  }
  vim.cmd.colorscheme 'gruvbox'
end

M.pywal.config = function()
  vim.cmd.colorscheme 'pywal'
end

M.gruvbox_baby.lazy = false
M.gruvbox_baby.priority = 1000
M.gruvbox_baby.config = function()
  vim.cmd.colorscheme 'gruvbox-baby'
end

M.kanagawa.config = function()
  require('kanagawa').setup {
    compile = false, -- enable compiling the colorscheme
    undercurl = true, -- enable undercurls
    commentStyle = { italic = true },
    keywordStyle = { italic = false },
    statementStyle = { bold = false },
    transparent = true, -- do not set background color
    dimInactive = false, -- dim inactive window `:h hl-NormalNC`
    terminalColors = true, -- define vim.g.terminal_color_{0,17}
    theme = 'dragon', -- Load "wave" theme when 'background' option is not set
  }
  vim.cmd.colorscheme 'kanagawa'
end

M.gruvbox_material.name = 'gruvbox-material'
M.gruvbox_material.lazy = false
M.gruvbox_material.priority = 1000
M.gruvbox_material.opts = {}
M.gruvbox_material.config = function()
  require('gruvbox-material').setup {
    italics = false, -- enable italics in general
    contrast = 'hard', -- set contrast, can be any of "hard", "medium", "soft"
    comments = {
      italics = true, -- enable italic comments
    },
    background = {
      transparent = true, -- set the background to transparent
    },
    float = {
      -- force_background = true, -- force background on floats even when background.transparent is set
      -- background_color = nil,  -- set color for float backgrounds. If nil, uses the default color set
      -- by the color scheme
    },
    signs = {
      highlight = true, -- whether to highlight signs
    },
    customize = nil, -- customize the theme in any way you desire, see below what this
  }
end

M.github.name = 'github-theme'
M.github.lazy = false -- make sure we load this during startup if it is your main colorscheme
M.github.priority = 1000 -- make sure to load this before all the other start plugins
M.github.config = function()
  vim.cmd 'colorscheme github_dark_dimmed'
end

return M.github
