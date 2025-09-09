# Neovim Configuration

This directory contains a Neovim configuration. It is a highly customized setup that uses a variety of plugins to enhance the editing experience.

## Project Overview

The configuration is written in Lua and is structured around a few key files:

*   `init.lua`: The main entry point for the configuration. It sets up the plugin manager and basic options.
*   `plugins.lua`: This file contains the configuration for all of the plugins used in the setup.
*   `keybindings.lua`: This file defines the custom keybindings for the user.
*   `plugins/`: This directory contains the plugin specifications.

The configuration uses the `simple_pm` plugin manager to handle the installation and loading of plugins.

### Key Plugins

The following is a list of some of the key plugins used in this configuration:

*   **[alpha](https://github.com/goolord/alpha-nvim)**: A dashboard for Neovim.
*   **[auto-session](https://github.com/rmagatti/auto-session)**: A session manager.
*   **[blink.cmp](https://github.com/Hoffs/blink.nvim)**: A completion plugin.
*   **[conform](https://github.com/stevearc/conform.nvim)**: A code formatter.
*   **[diffview.nvim](https://github.com/sindrets/diffview.nvim)**: A git diff viewer.
*   **[gitsigns.nvim](https://github.com/lewis6991/gitsigns.nvim)**: Git integration in the sign column.
*   **[luasnip](https://github.com/L3MON4D3/LuaSnip)**: A snippet engine.
*   **[mini.nvim](https://github.com/echasnovski/mini.nvim)**: A collection of minimal plugins for various functionalities.
*   **[neotest](https://github.com/nvim-neotest/neotest)**: A test runner.
*   **[rose-pine](https://github.com/rose-pine/neovim)**: A color scheme.
*   **[slimline.vim](https://github.com/j-morano/slimline.vim)**: A status line plugin.
*   **[snacks.nvim](https://github.com/Hoffs/snacks.nvim)**: A collection of utilities and toggles.
*   **[supermaven-nvim](https://github.com/supermaven-inc/supermaven-nvim)**: An AI-powered code completion plugin.
*   **[nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)**: A parser for syntax highlighting, indentation, and more.
*   **[ufo.vim](https://github.com/luukvbaal/ufo.vim)**: A code folding plugin.
*   **[illuminate](https://github.com/RRethy/vim-illuminate)**: A plugin to highlight the word under the cursor.

## Development Conventions

The configuration is written in Lua and follows the standard Lua style guidelines. The code is well-documented and easy to read.

The user has a number of custom keybindings that are defined in the `keybindings.lua` file. These keybindings are designed to improve the user's workflow and make it easier to access the various features of the configuration.
