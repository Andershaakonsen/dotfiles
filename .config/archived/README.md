# Archived configs

Configs that are no longer in active use, kept here in case I want to go back.

| Config | Replaced by | Notes |
|--------|-------------|-------|
| `yabai/` | AeroSpace (`../aerospace.toml`) | Tiling WM. launchd autostart services were already removed. |
| `skhd/` | AeroSpace keybindings | Hotkey daemon that paired with yabai. |
| `sketchybar/` | tmux status bar / native menu bar | Status bar that paired with yabai. |
| `alacritty/` | kitty (`../kitty/`) | Terminal emulator. |

## Restoring one

These used to be symlinked into `~/.config`. To re-activate, recreate the symlink, e.g.:

```sh
ln -s ~/dotfiles/.config/archived/alacritty ~/.config/alacritty
```

For yabai/skhd you'll also need to reinstall the tools and their launchd services.
