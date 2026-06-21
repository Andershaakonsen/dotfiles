#!/usr/bin/env bash
# Toggle "squeeze": maximize the active pane in both dimensions, leaving the
# other pane(s) as a thin sliver so the red active pane-border marks where the
# hidden pane is. Unlike `resize-pane -Z` (real zoom), the other pane stays
# visible as a line. Restores the EXACT original layout on toggle-off.
#
# The binding passes these in (tmux expands #{...} in run-shell), so this script
# avoids extra `tmux show-option`/`tmux display-message` round-trips:
#   $1 = current @squeezed value (saved layout string, or empty if not squeezed)
#   $2 = current window layout (#{window_layout})

saved="$1"
current="$2"

if [ -n "$saved" ]; then
  # Toggle off: restore the saved layout and clear the flag.
  tmux select-layout "$saved"
  tmux set-option -wu @squeezed
else
  # Toggle on: remember the current layout, then maximize the active pane.
  tmux set-option -w @squeezed "$current"
  tmux resize-pane -x 9999 -y 9999
fi
