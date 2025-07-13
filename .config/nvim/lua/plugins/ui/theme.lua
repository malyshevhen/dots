local M = {
  none = {},
  vscode = { 'Mofiqul/vscode.nvim' },
  gruvbox = { 'ellisonleao/gruvbox.nvim' },
  pywal = { 'AlphaTechnolog/pywal.nvim' },
  gruvbox_baby = { 'luisiacc/gruvbox-baby' },
  gruvbox_material = { 'f4z3r/gruvbox-material.nvim' },
  github = { 'projekt0n/github-nvim-theme' },
  kanagawa = { 'rebelot/kanagawa.nvim' },
  rose_pine = { 'rose-pine/neovim', name = 'rose-pine' },
  everforest = { 'neanias/everforest-nvim', name = 'everforest' },
  kanagawa_paper = { 'thesimonho/kanagawa-paper.nvim', lazy = false, priority = 1000, opts = {} },
}

M.kanagawa_paper.config = function()
  require('kanagawa-paper').setup {}
  vim.cmd.colorscheme 'kanagawa-paper'
end

M.everforest.version = false
M.everforest.lazy = false
M.everforest.priority = 1000 -- make sure to load this before all the other start plugins
-- Optional; default configuration will be used if setup isn't called.
M.everforest.config = function()
  require('everforest').setup {
    -- Your config here
    background = 'hard',
    ---How much of the background should be transparent. 2 will have more UI
    ---components be transparent (e.g. status line background)
    transparent_background_level = 0,
    ---Whether italics should be used for keywords and more.
    italics = false,
    ---Disable italic fonts for comments. Comments are in italics by default, set
    ---this to `true` to make them _not_ italic!
    disable_italic_comments = false,
    ---By default, the colour of the sign column background is the same as the as normal text
    ---background, but you can use a grey background by setting this to `"grey"`.
    sign_column_background = 'none',
    ---The contrast of line numbers, indent lines, etc. Options are `"high"` or
    ---`"low"` (default).
    ui_contrast = 'low',
    ---Dim inactive windows. Only works in Neovim. Can look a bit weird with Telescope.
    ---
    ---When this option is used in conjunction with show_eob set to `false`, the
    ---end of the buffer will only be hidden inside the active window. Inside
    ---inactive windows, the end of buffer filler characters will be visible in
    ---dimmed symbols. This is due to the way Vim and Neovim handle
    ---`EndOfBuffer`.
    dim_inactive_windows = false,
    ---Some plugins support highlighting error/warning/info/hint texts, by
    ---default these texts are only underlined, but you can use this option to
    ---also highlight the background of them.
    diagnostic_text_highlight = false,
    ---Which colour the diagnostic text should be. Options are `"grey"` or `"coloured"` (default)
    diagnostic_virtual_text = 'coloured',
    ---Some plugins support highlighting error/warning/info/hint lines, but this
    ---feature is disabled by default in this colour scheme.
    diagnostic_line_highlight = false,
    ---By default, this color scheme won't colour the foreground of |spell|, instead
    ---colored under curls will be used. If you also want to colour the foreground,
    ---set this option to `true`.
    spell_foreground = false,
    ---Whether to show the EndOfBuffer highlight.
    show_eob = true,
    ---Style used to make floating windows stand out from other windows. `"bright"`
    ---makes the background of these windows lighter than |hl-Normal|, whereas
    ---`"dim"` makes it darker.
    ---
    ---Floating windows include for instance diagnostic pop-ups, scrollable
    ---documentation windows from completion engines, overlay windows from
    ---installers, etc.
    ---
    ---NB: This is only significant for dark backgrounds as the light palettes
    ---have the same colour for both values in the switch.
    float_style = 'bright',
    ---Inlay hints are special markers that are displayed inline with the code to
    ---provide you with additional information. You can use this option to customize
    ---the background color of inlay hints.
    ---
    ---Options are `"none"` or `"dimmed"`.
    inlay_hints_background = 'none',
  }

  vim.cmd.colorscheme 'everforest'
end

M.rose_pine.config = function()
  require('rose-pine').setup {
    variant = 'moon', -- auto, main, moon, or dawn
    dark_variant = 'moon', -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    styles = {
      bold = false,
      italic = false,
      transparency = false,
    },

    groups = {
      border = 'muted',
      link = 'iris',
      panel = 'surface',

      error = 'love',
      hint = 'iris',
      info = 'foam',
      note = 'pine',
      todo = 'rose',
      warn = 'gold',

      git_add = 'foam',
      git_change = 'rose',
      git_delete = 'love',
      git_dirty = 'rose',
      git_ignore = 'muted',
      git_merge = 'iris',
      git_rename = 'pine',
      git_stage = 'iris',
      git_text = 'rose',
      git_untracked = 'subtle',

      h1 = 'iris',
      h2 = 'foam',
      h3 = 'rose',
      h4 = 'gold',
      h5 = 'pine',
      h6 = 'foam',
    },
  }

  vim.cmd.colorscheme 'rose-pine'
end

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
    theme = 'wave', -- Load "wave" theme when 'background' option is not set
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

return M.kanagawa_paper
