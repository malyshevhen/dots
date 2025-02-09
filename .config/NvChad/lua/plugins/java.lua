local M = { "nvim-java/nvim-java" }

M.ft = { "java" }

M.dependencies = {
  { "nvim-java/lua-async-await" },
  { "nvim-java/nvim-java-refactor" },
  { "nvim-java/nvim-java-core" },
  { "nvim-java/nvim-java-test" },
  { "nvim-java/nvim-java-dap" },
  { "MunifTanjim/nui.nvim" },
  { "neovim/nvim-lspconfig" },
  { "mfussenegger/nvim-dap" },
  { "JavaHello/spring-boot.nvim", commit = "218c0c26c14d99feca778e4d13f5ec3e8b1b60f0" },
  {
    "williamboman/mason.nvim",
    opts = {
      registries = {
        "github:nvim-java/mason-registry",
        "github:mason-org/mason-registry",
      },
    },
  },
}

M.config = function()
  require("mason-tool-installer").setup { ensure_installed = { "jdtls" } }

  local java = require "java"
  java.setup {}

  local map = vim.keymap.set

  -- Test keymap
  map("n", "<leader>jtm", java.test.run_current_method, { desc = "[J]ava [T]est [M]ethod" })
  map("n", "<leader>jtf", java.test.run_current_class, { desc = "[J]ava [T]est [F]ile" })
  map("n", "<leader>jtr", java.test.view_last_report, { desc = "[J]ava [T]est [R]eport" })

  -- Debug keymap
  map("n", "<leader>jdm", java.test.debug_current_method, { desc = "[J]ava [D]ebug [M]ethod" })
  map("n", "<leader>jdf", java.test.debug_current_class, { desc = "[J]ava [D]ebug [F]ile" })

  require("lspconfig").jdtls.setup {}
end

return M
