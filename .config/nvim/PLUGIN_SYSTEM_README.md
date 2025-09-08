# Simplified Neovim Plugin Management System

This directory contains a simplified plugin management system that replaces the complex existing plugin manager with a streamlined TOML-based approach.

## Overview

The system consists of:

1. **Plugin Definition**: `plugins.toml` - TOML file listing all plugins and dependencies
2. **Simple PM Module**: `lua/simple_pm/` - Complete plugin management system
   - `init.lua` - Main module interface
   - `toml_parser.lua` - Parses TOML configuration
   - `plugin_types.lua` - Type definitions and validation
   - `plugin_installer.lua` - Installs plugins and sources configuration
   - `keymap.lua` - Simplified keymap system (sets keymaps immediately)
   - `compat.lua` - Compatibility layer for existing K:map syntax
3. **Simple Init**: `simple_init.lua` - Simplified entry point

## File Structure

```
~/.config/nvim/
├── plugins.toml              # Plugin definitions (REQUIRED)
├── simple_init.lua           # New simplified init.lua
├── plugins.lua               # Plugin configurations (OPTIONAL)
├── plugins/                  # Plugin configurations directory (OPTIONAL)
│   ├── editor.lua
│   ├── lsp.lua
│   └── ui.lua
├── keybindings.lua           # Keybindings (OPTIONAL)
├── keybindings/              # Keybindings directory (OPTIONAL)
│   ├── editor.lua
│   ├── git.lua
│   └── lsp.lua
└── lua/
    ├── simple_pm/            # Simple plugin management system
    │   ├── init.lua          # Main module interface
    │   ├── plugin_types.lua  # Type definitions
    │   ├── toml_parser.lua   # TOML parser
    │   ├── plugin_installer.lua  # Plugin installer
    │   ├── keymap.lua        # Simplified keymap system
    │   ├── compat.lua        # K:map compatibility layer
    │   └── README.md         # Detailed documentation
    ├── options.lua           # Vim options (existing)
    ├── auto_cmds.lua         # Autocommands (existing)
    └── lsp_cfg.lua           # LSP configuration (existing)
```

## How It Works

### 1. Plugin Definition (`plugins.toml`)

Define all plugins and their dependencies in a single TOML file:

```toml
[[plugins]]
name = "nvim-treesitter"
src = "https://github.com/nvim-treesitter/nvim-treesitter"

[[plugins]]
name = "telescope.nvim"
src = "https://github.com/nvim-telescope/telescope.nvim"
dependencies = [
  "https://github.com/nvim-lua/plenary.nvim",
  "https://github.com/nvim-telescope/telescope-fzf-native.nvim"
]

[[plugins]]
name = "rose-pine"
src = "https://github.com/rose-pine/neovim"
version = "v3.0.0"
```

### 2. Plugin Installation

The system automatically:

- Parses `plugins.toml`
- Validates the configuration
- Flattens dependencies into individual plugin entries
- Installs plugins using `vim.plug.add`
- Sources configuration files in the correct order

### 3. Simplified Keymap System

The new system sets keymaps **immediately** when they're declared, instead of collecting them and setting them in batch. This means:

- **No collection phase** - keymaps work as soon as they're defined
- **Existing syntax works** - your current `K:map` calls continue to work unchanged
- **Immediate feedback** - errors are caught and reported right away
- **Compatible interface** - drop-in replacement for the existing system

### 4. Configuration Sourcing Order

After plugin installation, files are sourced in this order:

1. **Plugin Configuration**:
   - `plugins.lua` (if exists)
   - All `*.lua` files in `plugins/` directory (non-recursive)

2. **Keybindings**:
   - `keybindings.lua` (if exists)
   - All `*.lua` files in `keybindings/` directory (non-recursive)

## Usage

### Getting Started

1. **Your plugin management system is ready** - all files are in `lua/simple_pm/`

2. **Replace your init.lua**:

   ```bash
   mv ~/.config/nvim/init.lua ~/.config/nvim/init.lua.backup
   mv ~/.config/nvim/simple_init.lua ~/.config/nvim/init.lua
   ```

3. **Your `plugins.toml` is already configured** and ready to use.

4. **Existing keymaps continue to work** - no changes needed to `K:map` calls

5. **Create configuration files** (optional):

   ```bash
   # Create plugin configuration
   touch ~/.config/nvim/plugins.lua
   # OR create plugin configuration directory
   mkdir ~/.config/nvim/plugins

   # Create keybindings
   touch ~/.config/nvim/keybindings.lua
   # OR create keybindings directory
   mkdir ~/.config/nvim/keybindings
   ```

### Configuration Examples

**Plugin Configuration** (`plugins.lua` or `plugins/theme.lua`):

```lua
-- Configure rose-pine theme
require('rose-pine').setup({
  variant = 'moon',
  dark_variant = 'moon',
})
vim.cmd('colorscheme rose-pine')

-- Configure treesitter
require('nvim-treesitter.configs').setup({
  ensure_installed = { 'lua', 'python', 'javascript' },
  highlight = { enable = true },
})
```

**Keybindings** (`keybindings.lua` or `keybindings/editor.lua`):

```lua
-- Set leader key
vim.g.mapleader = ' '

-- File operations
vim.keymap.set('n', '<leader>w', '<cmd>w<CR>', { desc = 'Save file' })
vim.keymap.set('n', '<leader>q', '<cmd>q<CR>', { desc = 'Quit' })

-- Plugin-specific keybindings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<CR>', { desc = 'Find files' })
```

## Plugin Schema

The system includes a JSON schema for `plugins.toml` validation. Each plugin entry supports:

- `name` (optional): Human-readable plugin name
- `src` (required): HTTPS URL to the plugin repository
- `version` (optional): Version tag, branch, or commit
- `dependencies` (optional): Array of dependency URLs

## Commands

- `:SimplePMDebugPlugins` - Show all parsed plugins without installing
- `:SimplePMTestKeymaps` - Test the simplified keymap system
- `:SimplePMReinstall` - Reinstall plugins and source configuration

## Migration from Existing System

1. **Backup your current configuration**:

   ```bash
   cp -r ~/.config/nvim ~/.config/nvim.backup
   ```

2. **Your `plugins.toml` already contains all required plugins**

3. **Extract plugin configurations**:
   - Move plugin setup code from `lua/plugins/*.lua` to `plugins.lua` or `plugins/` directory
   - Move keybinding code to `keybindings.lua` or `keybindings/` directory

4. **Switch to the new init.lua**:
   ```bash
   mv ~/.config/nvim/init.lua ~/.config/nvim/old_init.lua
   mv ~/.config/nvim/simple_init.lua ~/.config/nvim/init.lua
   ```

## Advantages

- **Simplified**: One TOML file for all plugin definitions
- **Immediate keymaps**: Keymaps work as soon as they're declared (no batching)
- **Full compatibility**: Existing `K:map` syntax continues to work unchanged
- **Declarative**: Clear separation between plugin definition and configuration
- **Automatic**: Dependencies are automatically resolved and installed
- **Flexible**: Multiple ways to organize configuration files
- **Type-safe**: Built-in validation with Lua types and JSON schema
- **Standard**: Uses `vim.plug.add` (Neovim's built-in plugin system)

## Troubleshooting

### Debug Plugin Parsing

```vim
:SimplePMDebugPlugins
```

### Test Keymap System

```vim
:SimplePMTestKeymaps
```

### Check Log Messages

Plugin installation messages appear in Neovim's message area. Use `:messages` to review them.

### Validate TOML Syntax

The system will show parsing errors if `plugins.toml` has syntax issues.

### File Not Found Errors

- Ensure `plugins.toml` exists in your config root
- Optional configuration files (`plugins.lua`, `keybindings.lua`) are silently skipped if missing

## Architecture

The system follows these principles:

- **Separation of Concerns**: Plugin definition, installation, and configuration are separate
- **Fail-Safe**: Missing optional files don't break the system
- **Extensible**: Easy to add new configuration sources
- **Maintainable**: Simple, readable code with clear responsibilities

## Performance

- **Fast Startup**: Minimal overhead compared to complex plugin managers
- **Efficient**: Only parses TOML once during initialization
- **Lazy Loading**: Can be extended with lazy loading if needed

---

_This system replaces the complex pm/ directory structure with a simple, maintainable approach focused on clarity and immediate feedback. The plugin management code is now organized in `lua/simple_pm/` with comprehensive documentation._

## Detailed Documentation

For complete API reference, examples, and troubleshooting, see:

- `lua/simple_pm/README.md` - Comprehensive system documentation
- `keybindings_example.lua` - Example keymap configuration
- `example_plugins.lua` - Example plugin configuration
