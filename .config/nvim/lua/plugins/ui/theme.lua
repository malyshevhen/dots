---@diagnostic disable-next-line: unused-local
local vscode = {
  'Mofiqul/vscode.nvim',
  config = function()
    -- Lua:
    -- For dark theme (neovim's default)
    vim.o.background = 'dark'
    -- For light theme
    -- vim.o.background = 'light'

    local c = require('vscode.colors').get_colors()
    require('vscode').setup {
      -- Alternatively set style in setup
      -- style = 'light'

      -- Enable transparent background
      transparent = true,

      -- Enable italic comment
      italic_comments = true,

      -- Underline `@markup.link.*` variants
      underline_links = true,

      -- Disable nvim-tree background color
      disable_nvimtree_bg = true,

      -- Override colors (see ./lua/vscode/colors.lua)
      color_overrides = {
        vscLineNumber = '#FFFFFF',
      },

      float = {
        background_color = nil, -- set color for float backgrounds. If nil, uses the default color set
      },

      -- Override highlight groups (see ./lua/vscode/theme.lua)
      group_overrides = {
        -- this supports the same val table as vim.api.nvim_set_hl
        -- use colors from this colorscheme by requiring vscode.colors!
        Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
      },
    }
    -- require('vscode').load()

    -- load the theme without affecting devicon colors.
    vim.cmd.colorscheme 'vscode'
  end,
}
---@diagnostic disable-next-line: unused-local
local gruvbox = {
  'ellisonleao/gruvbox.nvim',
  lazy = false,
  priority = 1000,
  config = function()
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
      transparent_mode = true,
    }
    vim.cmd.colorscheme 'gruvbox'
  end,
}

---@diagnostic disable-next-line: unused-local
local pywal = {
  'AlphaTechnolog/pywal.nvim',
  config = function()
    vim.cmd.colorscheme 'pywal'
  end,
}

---@diagnostic disable-next-line: unused-local
local gruvbox_baby = {
  'luisiacc/gruvbox-baby',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'gruvbox-baby'
  end,
}

---@diagnostic disable-next-line: unused-local
local kanagawa = {
  'rebelot/kanagawa.nvim',
  config = function()
    vim.cmd.colorscheme 'kanagawa'

    require('kanagawa').setup {
      compile = false, -- enable compiling the colorscheme
      undercurl = true, -- enable undercurls
      commentStyle = { italic = true },
      functionStyle = {},
      keywordStyle = { italic = false },
      statementStyle = { bold = false },
      typeStyle = {},
      transparent = true, -- do not set background color
      dimInactive = false, -- dim inactive window `:h hl-NormalNC`
      terminalColors = true, -- define vim.g.terminal_color_{0,17}
      colors = { -- add/modify theme and palette colors
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
      },
      -- overrides = function(colors) -- add/modify highlights
      --   return {}
      -- end,
      theme = 'dragon', -- Load "wave" theme when 'background' option is not set
      background = { -- map the value of 'background' option to a theme
        -- dark = 'dragon', -- try "dragon" !
        -- light = 'lotus',
      },
      overrides = {},
    }
  end,
}

---@diagnostic disable-next-line: unused-local
local gruvbox_material = {
  {
    'f4z3r/gruvbox-material.nvim',
    name = 'gruvbox-material',
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      -- values shown are defaults and will be used if not provided
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
        -- configuration accepts
      }
    end,
  },
}

local current_theme = {}

return current_theme
