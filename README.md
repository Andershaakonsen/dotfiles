# Dotfiles

Personal macOS development environment configuration.

## Features

- **Neovim**: LazyVim-based setup with AI assistance (Supermaven, Avante)
- **Shell**: Zsh with Oh My Zsh, Powerlevel10k theme, zoxide smart navigation, and productivity aliases
- **Terminal**: Ghosty, Kitty and Alacritty configurations
- **Window Manager**: AeroSpace tiling window manager with vim-style navigation
- **Tools**: Custom tmux scripts, window management configs

## Key Aliases

- `v` - Neovim
- `lg` - Lazygit
- `dw` - `dotnet watch --launch-profile https`
- `dcup/dcd` - Docker compose up/down
- `z` - [zoxide](https://github.com/ajeetdsouza/zoxide) smart `cd` (jump to frequently-used dirs)

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
- `.config/aerospace.toml` - AeroSpace window manager configuration
- `.config/tmux/` - tmux configuration (prefix `C-Space`; `prefix+m` squeeze, `prefix+M` zoom)
- `.config/kitty/` - Terminal emulator
- `.config/archived/` - Retired configs kept for reference (yabai, skhd, sketchybar, alacritty)
- `scripts/` - Custom tmux utilities
- `claude/hooks/` - Claude Code hooks (symlinked into `~/.claude/hooks/`)

## Claude Code

Custom hooks live in `claude/hooks/` and are symlinked into `~/.claude/` (which is not itself part of this repo).

- **`herdr-zoom-notify.sh`** — a `Stop` hook that fires a herdr notification when a Claude agent finishes but its pane is hidden *within the focused workspace* (zoomed away, or on an inactive tab). This covers the gap herdr's built-in notifications miss (herdr only notifies for agents in *background* workspaces).

Setup on a fresh machine:

```bash
# 1. Symlink the hook into ~/.claude
ln -s ~/dotfiles/claude/hooks/herdr-zoom-notify.sh ~/.claude/hooks/herdr-zoom-notify.sh

# 2. Register it as a Stop hook in ~/.claude/settings.json (personal, not committed):
#   "hooks": { "Stop": [ { "hooks": [ {
#     "type": "command",
#     "command": "bash '/Users/<you>/.claude/hooks/herdr-zoom-notify.sh'",
#     "timeout": 10, "async": true
#   } ] } ] }
```
