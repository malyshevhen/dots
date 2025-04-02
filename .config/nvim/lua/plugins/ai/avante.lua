local M = { 'yetone/avante.nvim' }

M.dependencies = {
  'nvim-treesitter/nvim-treesitter',
  'stevearc/dressing.nvim',
  'nvim-lua/plenary.nvim',
  'MunifTanjim/nui.nvim',
  --- The below dependencies are optional,
  'ibhagwan/fzf-lua', -- for file_selector provider fzf
  'echasnovski/mini.icons',
  'zbirenbaum/copilot.lua', -- for providers='copilot'
  {
    -- support for image pasting
    'HakonHarnes/img-clip.nvim',
    event = 'VeryLazy',
    opts = {
      -- recommended settings
      default = {
        embed_image_as_base64 = false,
        prompt_for_file_name = false,
        drag_and_drop = {
          insert_mode = true,
        },
        -- required for Windows users
        use_absolute_path = true,
      },
    },
  },
  {
    -- Make sure to set this up properly if you have lazy=true
    'MeanderingProgrammer/render-markdown.nvim',
    opts = {
      file_types = { 'markdown', 'Avante' },
    },
    ft = { 'markdown', 'Avante' },
  },
}

M.event = 'VeryLazy'

M.version = false -- Never set this value to "*"! Never!

M.opts = {
  provider = 'gemini',
}
-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
M.build = 'make'

-- Custom hack to force gemini to load instead of claude
M.init = function()
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      -- Ensure Avante.nvim has been loaded before switching providers
      if vim.fn.exists ':AvanteSwitchProvider' == 2 then
        vim.cmd 'AvanteSwitchProvider gemini'
      end
    end,
  })
end

return M
