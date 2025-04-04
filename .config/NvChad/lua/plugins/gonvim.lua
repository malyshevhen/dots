local M = { "ray-x/go.nvim" }

M.dependencies = { -- optional packages
  "ray-x/guihua.lua",
  "neovim/nvim-lspconfig",
  "nvim-treesitter/nvim-treesitter",
  "theHamsta/nvim-dap-virtual-text",
}

M.config = function()
  require("go").setup()
end

M.event = { "CmdlineEnter" }

M.ft = { "go", "gomod" }

M.keys = {
  -- { "<Leader>gla", "<cmd>GoCodeLenAct<cr>", desc = "[G]o [C]lens [A]ction" },
  -- { "<Leader>gft", "<cmd>GoFillStruct<cr>", desc = "[G]o [F]ill [S]truct" },
  -- { "<Leader>gI", "<cmd>GoImports<cr>", desc = "[G]o [I]mports" },
  -- { "<Leader>gtf", "<cmd>GoTestFunc<cr>", desc = "[G]o [T]est [F]unc" },
  -- { "<Leader>gtp", "<cmd>GoTestPkg<cr>", desc = "[G]o [T]est [P]ackage" },
  -- { "<Leader>gtl", "<cmd>GoTestFile<cr>", desc = "[G]o [T]est Fi[l]e" },
  -- { "<Leader>gat", "<cmd>GoAddTag<cr>", desc = "[G]o [A]dd [T]ag" },
  -- { "<Leader>gcg", "<cmd>GoGenerate<cr>", desc = "[G]o [C]ode [G]enerate" },
  -- { "<Leader>ge", "<cmd>GoIfErr<cr>", desc = "If [Er]r" },
}

return M
