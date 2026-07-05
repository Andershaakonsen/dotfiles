#!/usr/bin/env bash
# Tint the focused kitty window's background based on the tmux session.
#
# Called from tmux hooks (client-session-changed / client-attached) with the
# current session name as $1. When that session is "satoru" (the vault) the
# background shifts to a warm/yellow dark tone; any other session resets it to
# the configured kitty colors. Only the focused OS window is affected.
#
# Requires kitty remote control:  allow_remote_control socket-only
#                                 listen_on unix:/tmp/mykitty

session="$1"
kitten="/opt/homebrew/bin/kitten"

# Warm/yellow tint for the satoru vault (base bg is #1E1E2E). Tweak to taste.
tint="#35311d"

[ -x "$kitten" ] || exit 0

# kitty appends "-<pid>" to the listen_on path, so the socket is
# /tmp/mykitty-<pid>, not /tmp/mykitty. Grab the current one.
sock_path=$(ls -t /tmp/mykitty-* 2>/dev/null | head -1)
[ -n "$sock_path" ] || exit 0
sock="unix:$sock_path"

if [ "$session" = "satoru" ]; then
	"$kitten" @ --to "$sock" set-colors --match state:focused "background=$tint" >/dev/null 2>&1
else
	"$kitten" @ --to "$sock" set-colors --match state:focused --reset >/dev/null 2>&1
fi

exit 0
