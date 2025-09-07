---@class AutoCmds
local M = {}

function M.setup()
  --- Autocmds
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('Highlight-yank', { clear = true }),
    callback = function()
      vim.highlight.on_yank()
    end,
  })

  --- Indentation
  vim.cmd 'filetype plugin indent on'

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'javascript', 'typescript', 'json', 'yaml' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'lua' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'python' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.tabstop = 4
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'go' },
    callback = function()
      vim.bo.expandtab = false
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.tabstop = 4
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'make' },
    callback = function()
      vim.bo.expandtab = false
      vim.bo.shiftwidth = 8
      vim.bo.tabstop = 8
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sh' },
    callback = function()
      vim.bo.expandtab = false
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'sql' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 4
      vim.bo.softtabstop = 4
      vim.bo.tabstop = 4
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'gleam' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'raml' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = { 'elixir' },
    callback = function()
      vim.bo.expandtab = true
      vim.bo.shiftwidth = 2
      vim.bo.softtabstop = 2
      vim.bo.tabstop = 2
    end,
  })

  vim.filetype.add {
    pattern = {
      ['docker-compose%.yml'] = 'yaml.docker-compose',
      ['docker-compose%.yaml'] = 'yaml.docker-compose',
      ['compose%.yml'] = 'yaml.docker-compose',
      ['compose%.yaml'] = 'yaml.docker-compose',
      ['*.raml'] = 'raml',
    },
  }
end

return M
