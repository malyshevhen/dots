-- Simplified Neovim Configuration Entry Point
-- This file uses the new simplified plugin management system

-- Load basic options first (if they exist)
local options_file = vim.fn.stdpath 'config' .. '/lua/options.lua'
if vim.fn.filereadable(options_file) == 1 then
  require 'options'
end

-- Initialize the simplified plugin system
local simple_pm = require 'simple_pm'

-- Set up the plugin management system with automatic configuration sourcing
simple_pm.init {
  auto_source_configs = true,
  auto_setup_keymaps = true,
  debug_mode = false, -- Set to true for debugging
}

-- Load additional configuration that should happen after plugins
local auto_cmds_file = vim.fn.stdpath 'config' .. '/lua/auto_cmds.lua'
if vim.fn.filereadable(auto_cmds_file) == 1 then
  require 'auto_cmds'
end

local lsp_cfg_file = vim.fn.stdpath 'config' .. '/lua/lsp_cfg.lua'
if vim.fn.filereadable(lsp_cfg_file) == 1 then
  require 'lsp_cfg'
end
