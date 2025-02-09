require("nvchad.configs.lspconfig").defaults()

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

require("mason").setup()

local servers = require("configs.lsp.servers")

local ensure_installed = vim.tbl_keys(servers or {})
vim.list_extend(ensure_installed, {
  "stylua",
  "gofumpt",
  "impl",
  "goimports",
  "delve",
  "gomodifytags",
  "hadolint",
  "markdownlint-cli2",
  "markdown-toc",
})
require("mason-tool-installer").setup { ensure_installed = ensure_installed }

local configs = require "nvchad.configs.lspconfig"

for name, opts in pairs(servers) do
  if name == "ltex" then
    require("lspconfig")[name].setup {
      on_attach = function(client, bufnr)
        -- your other on_attach code
        -- for example, set keymaps here, like
        -- vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        -- (see below code block for more details)
        require("ltex-utils").on_attach(bufnr)
      end,
    }
  end

  opts.on_init = configs.on_init
  opts.on_attach = configs.on_attach
  opts.capabilities = configs.capabilities

  require("lspconfig")[name].setup(opts)
end
