# Plugin Manager System

A modern, safe, and efficient plugin management system for Neovim that loads keymaps first, then plugins, with comprehensive error handling and debugging capabilities.

## Overview

This plugin manager system consists of several utilities:

- **`files.lua`**: Safe file loading utilities using Vim's native APIs
- **`loader.lua`**: High-level loading functions for keymaps and plugins
- **`debug.lua`**: Comprehensive debugging and analysis tools
- **`plugin_manager.lua`**: Main plugin manager with keymap handling
- **`init.lua`**: Convenient initialization and setup functions

## Key Features

- **Keymaps First**: Loads `keymaps.lua` before any plugins
- **Safe Loading**: Comprehensive error handling with detailed reporting
- **Directory Walking**: Recursively loads all Lua files from plugins directory
- **Debug Tools**: Built-in analysis and debugging capabilities
- **Vim API Native**: Uses `vim.fn` functions for file operations

## Quick Start

### Basic Setup

```lua
-- In your init.lua or plugin configuration
local pm = require('pm')

-- Simple setup - loads keymaps first, then plugins
local results = pm.setup()

-- With debug mode enabled
local results = pm.setup(true, true) -- keymaps_first=true, debug_mode=true
```

### Manual Initialization

```lua
local pm = require('pm')

-- Custom configuration
local results = pm.init({
  keymaps_path = vim.fn.stdpath('config') .. '/lua/my_keymaps.lua',
  plugins_dir = vim.fn.stdpath('config') .. '/lua/my_plugins',
  options = { silent = false },
  setup_debug_commands = true
})

-- Check results
if results.keymaps.success then
  print('Keymaps loaded successfully')
end

print(string.format('Plugins: %d/%d loaded successfully',
  results.plugins.success_count, results.plugins.total))
```

## File Structure Expected

```
~/.config/nvim/lua/
├── keymaps.lua              # Main keymaps file
├── plugins/                 # Plugin directory
│   ├── alpha.lua           # Individual plugin files
│   ├── autopairs.lua
│   ├── conform.lua
│   └── ...
└── pm/                     # Plugin manager system
    ├── init.lua
    ├── plugin_manager.lua
    └── utils/
        ├── files.lua
        ├── loader.lua
        └── debug.lua
```

## Keymaps File Format

Your `keymaps.lua` should use the global `K` keymap store:

```lua
-- keymaps.lua
K:map {
  -- System clipboard operations
  { map = '<leader>y',  cmd = '"+y',                     desc = 'Yank (Clipboard)',    mode = { 'v', 'x' } },
  { map = '<leader>p',  cmd = '"+p',                     desc = 'Paste (Clipboard)',   mode = { 'v', 'x' } },

  -- Window navigation
  { map = '<c-k>',      cmd = ':wincmd k<CR>',           desc = 'Move to top pane' },
  { map = '<c-j>',      cmd = ':wincmd j<CR>',           desc = 'Move to bottom pane' },

  -- LSP operations
  { map = '<leader>cr', cmd = vim.lsp.buf.rename,        desc = 'Code Rename',         mode = { 'n' } },
  { map = '<leader>ca', cmd = vim.lsp.buf.code_action,   desc = 'Code Action',         mode = { 'n', 'v' } },
}
```

## Plugin File Format

Each plugin file should use the global `P` plugin manager:

```lua
-- plugins/example.lua
P:add('https://github.com/author/plugin-name', 'plugin-name', {
  opts = {
    -- Plugin configuration
    some_option = true,
  },

  config = function()
    -- Custom setup code
    require('plugin-name').setup({
      -- Plugin options
    })
  end,

  keymaps = {
    { map = '<leader>ex', cmd = '<cmd>ExampleCommand<cr>', desc = 'Example Command' },
  },

  deps = {
    'https://github.com/dependency/repo',
  },
})

-- Plugin-specific keymaps (will be collected automatically)
K:map {
  { map = '<leader>xx', cmd = '<cmd>PluginCommand<cr>', desc = 'Plugin Command' },
}
```

## Debug Commands

When debug mode is enabled, several commands become available:

### `:PluginManagerDebug`
Comprehensive analysis of the initialization process:
```
==================================================
PLUGIN MANAGER INITIALIZATION DEBUG
==================================================

Analysis of /path/to/keymaps
============================
Total Lua files: 1
File details:
  1. keymaps (lua/keymaps.lua) - modified: 2024-01-15 10:30:15

Analysis of /path/to/plugins
============================
Total Lua files: 15
Subdirectories:
  .: 15 files

[DEBUG] Starting keymap loading analysis...
[DEBUG] ✓ Keymaps loaded successfully (12 new keymaps)

[DEBUG] Starting plugin loading analysis...
[DEBUG] ✓ Successfully loaded plugins:
  ✓ plugins.alpha (lua/plugins/alpha.lua)
  ✓ plugins.conform (lua/plugins/conform.lua)
  ...
```

### `:PluginManagerState`
Shows current plugin manager state:
```
[DEBUG] CURRENT PLUGIN MANAGER STATE
Plugins registered: 15
  1. alpha (https://github.com/goolord/alpha-nvim) - 0 keymaps
  2. conform (https://github.com/stevearc/conform.nvim) - 2 keymaps
  ...

Keymaps registered: 45
  1. [v,x] <leader>y - Yank (Clipboard)
  2. [n] <c-k> - Move to top pane
  ...
```

### `:PluginManagerAnalyze [directory]`
Analyzes a specific directory for Lua files.

## Advanced Usage

### Using Utilities Directly

```lua
local files = require('pm.utils.files')
local loader = require('pm.utils.loader')

-- Get all Lua files in a directory
local lua_files = files.get_lua_files('/path/to/plugins', true)

-- Load plugins with custom options
local results = loader.load_plugins_with_require('/path/to/plugins', {
  silent = true,
  filter = function(filepath, result)
    -- Custom filtering logic
    return result ~= nil
  end
})

-- Check file existence and modification time
if files.file_exists('config.lua') then
  local mtime = files.get_mtime('config.lua')
  print('Last modified:', os.date('%c', mtime))
end
```

### State Management

```lua
local pm = require('pm')

-- Get current state
local state = pm.get_state()
print('Plugins loaded:', state.plugins.count)
print('Keymaps registered:', state.keymaps.count)

-- Reload keymaps
pm.reload_keymaps() -- Uses default path
pm.reload_keymaps('/custom/path/to/keymaps.lua')

-- Reload plugins (note: doesn't unload existing plugins)
pm.reload_plugins()
```

## Error Handling

The system provides comprehensive error handling:

- **File Not Found**: Clear warnings when keymaps or plugin files are missing
- **Loading Errors**: Detailed error messages with file paths and error descriptions
- **Validation**: Checks for required fields in plugin and keymap definitions
- **Graceful Degradation**: Continues loading other files even if some fail

## Migration from Old System

If you're migrating from the old plugin loading system:

1. **Update plugin files**: Change from individual `require()` calls to using `P:add()`
2. **Consolidate keymaps**: Move all keymaps to `keymaps.lua` using `K:map`
3. **Update initialization**: Replace old loading code with `pm.setup()`

Example migration:

```lua
-- OLD WAY
require('plugins.alpha')
require('plugins.conform')
-- ... many more requires

-- NEW WAY
local pm = require('pm')
pm.setup() -- Loads everything automatically
```

## Performance Notes

- **Lazy Loading**: Plugin files are only loaded when the plugin manager runs
- **Error Recovery**: Failed plugin loads don't stop the entire process
- **Efficient File Walking**: Uses Vim's native `readdir()` for directory traversal
- **Module Caching**: Leverages Lua's `require()` caching for repeated loads

## Troubleshooting

### Common Issues

1. **Keymaps not loading**: Check that `keymaps.lua` exists and uses `K:map` syntax
2. **Plugins not found**: Verify plugin files are in the plugins directory and use `P:add` syntax
3. **Debug commands not available**: Ensure `setup_debug_commands = true` in configuration

### Debug Steps

1. Enable debug mode: `pm.setup(true, true)`
2. Run `:PluginManagerDebug` to see detailed loading information
3. Check `:PluginManagerState` to verify current state
4. Use `:PluginManagerAnalyze` to examine directory structure

## Contributing

When adding new features:

1. Add comprehensive error handling
2. Include debug information
3. Update this README with examples
4. Test with various file structures
5. Ensure Vim API compatibility
