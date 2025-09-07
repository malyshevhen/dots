-- Neovim Configuration Entry Point
-- This file initializes the complete Neovim configuration in the correct order

-- Step 1: Load basic options and leader key first (required for keymaps)
require('options').setup()

-- Step 2: Initialize the plugin manager system
-- This will:
-- 1. Create global P (PluginManager) and K (KeymapsStore) instances
-- 2. Load keymaps from lua/keymaps.lua
-- 3. Load all plugins from lua/plugins/ directory
require('pm.plugin_manager').plugin_manager():init():setup()

-- Step 3: Set up autocmds
require('auto_cmds').setup()

-- Step 4: Enable LSP servers
require('lsp_cfg').enable()

-- Alternative comprehensive initialization using the new pm.init module:
-- This method automatically loads options, keymaps, plugins, auto_cmds, and lsp_cfg
-- local pm = require('pm')
-- local results = pm.init({
--   options_module = 'options',
--   keymaps_path = vim.fn.stdpath('config') .. '/lua/keymaps.lua',
--   plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins',
--   auto_cmds_module = 'auto_cmds',
--   lsp_cfg_module = 'lsp_cfg',
--   setup_debug_commands = false,
-- })

-- For debugging, use:
-- local pm = require('pm')
-- pm.setup(true, true) -- keymaps_first=true, debug_mode=true
-- This will enable debug commands like :PluginManagerDebug, :PluginManagerState, etc.
