# Dotfiles

Personal macOS development environment configuration.

## Features

- **Neovim**: LazyVim-based setup with AI assistance (Supermaven, Avante)
- **Shell**: Zsh with Oh My Zsh, Powerlevel10k theme, and productivity aliases
- **Terminal**: Kitty and Alacritty configurations
- **Tools**: Custom tmux scripts, window management configs

## Key Aliases

- `v` - Neovim
- `lg` - Lazygit  
- `dw` - `dotnet watch --launch-profile https`
- `dcup/dcd` - Docker compose up/down

## Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
# Symlink configs as needed
```

## Neovim Setup

Built on [LazyVim](https://lazyvim.org) with custom plugins and keymaps.

### Key Plugins
- **Harpoon** - Quick file navigation (`<leader>1-5`, `<C-e>`)
- **Telescope** - Fuzzy finder (`<leader>ff`, `<leader>fs`)
- **Oil.nvim** - Directory editing
- **Obsidian** - Note-taking integration
- **Octo** - GitHub workflow integration
- **Avante** - AI assistance
- **Supermaven** - Code completion

### Custom Keymaps
- `<leader>w` - Save all files
- `<leader>a` - Add file to Harpoon
- `<C-h/j/k/l>` - Navigate between tmux panes and vim splits
- Window management: `<leader>sv/sh/se/sx`

### Languages Configured
TypeScript, JSON, Markdown, Tailwind CSS, TOML

## Structure

- `.config/nvim/` - Neovim configuration
- `.config/yabai/` - Window manager (disabled)
- `.config/kitty/` - Terminal emulator
- `scripts/` - Custom tmux utilities
