#!/usr/bin/env bash
# Sync herdr's active-row highlight color to the macOS system appearance.
#
# herdr's theme.auto_switch already flips the *base* palette (catppuccin /
# catppuccin-latte) with the system appearance, but its [theme.custom] override
# is a SINGLE global table — there is no light/dark split. Our custom navy
# (#2f2b45) that makes the active sidebar row pop in dark mode therefore bleeds
# into light mode as an out-of-place dark band.
#
# Workaround: rewrite the three elevated-surface tokens in config.toml to a
# palette-appropriate value for the current appearance, then hot-reload herdr.
# Triggered event-driven by Hammerspoon on AppleInterfaceThemeChangedNotification
# (and once at Hammerspoon load). See .config/hammerspoon/init.lua.
#
# NOTE: this edits the version-controlled config.toml in place, so `git status`
# will show it as modified whenever the appearance differs from the committed
# value (committed = dark). Run `git update-index --skip-worktree <file>` if the
# churn is annoying.
set -euo pipefail

CONFIG="${HOME}/dotfiles/.config/herdr/config.toml"
HERDR="/opt/homebrew/bin/herdr"

# Elevated-surface color per appearance:
#   dark  -> catppuccin mocha, subtle navy lift over base #1e1e2e
#   light -> catppuccin latte surface0, subtle darken under base #eff1f5
DARK="#2f2b45"
LIGHT="#ccd0da"

if defaults read -g AppleInterfaceStyle 2>/dev/null | grep -qi dark; then
  COLOR="$DARK"
else
  COLOR="$LIGHT"
fi

[ -f "$CONFIG" ] || exit 0

# Replace the hex on surface / surface_dim / overlay assignments only.
# Longest key first so `surface` doesn't shadow `surface_dim` under leftmost-longest.
/usr/bin/sed -i '' -E \
  "s@^(surface_dim|surface|overlay)([[:space:]]*=[[:space:]]*)\"#[0-9a-fA-F]{6}\"@\1\2\"${COLOR}\"@" \
  "$CONFIG"

# Hot-reload the running server; quietly no-op if none is up.
"$HERDR" server reload-config >/dev/null 2>&1 || true
