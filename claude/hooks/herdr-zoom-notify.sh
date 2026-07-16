#!/bin/sh
# Custom Stop hook (lives beside the herdr-managed herdr-agent-state.sh, which
# must not be edited). Fires a herdr notification when the Claude agent finishes
# but its pane is NOT currently visible *within the focused workspace* — i.e.
# the case herdr's built-in notifications miss:
#   - the pane is zoomed away (another pane in the tab is zoomed), or
#   - the pane sits on a non-active tab of the focused workspace.
#
# herdr already notifies for agents in *background* workspaces, so this hook is
# deliberately scoped to the FOREGROUND workspace only — no double-notification.

set -eu

# Consume stdin (Claude passes hook JSON there) so Claude isn't left blocking.
cat >/dev/null 2>&1 || true

[ "${HERDR_ENV:-}" = "1" ] || exit 0
[ -n "${HERDR_PANE_ID:-}" ] || exit 0
command -v herdr >/dev/null 2>&1 || exit 0
command -v python3 >/dev/null 2>&1 || exit 0

layout="$(herdr pane layout --pane "$HERDR_PANE_ID" 2>/dev/null)" || exit 0
workspaces="$(herdr workspace list 2>/dev/null)" || exit 0

HZN_PANE="$HERDR_PANE_ID" HZN_LAYOUT="$layout" HZN_WORKSPACES="$workspaces" python3 - <<'PY'
import json
import os
import subprocess

pane = os.environ.get("HZN_PANE")
try:
    layout = json.loads(os.environ["HZN_LAYOUT"])["result"]["layout"]
    workspaces = json.loads(os.environ["HZN_WORKSPACES"])["result"]["workspaces"]
except Exception:
    raise SystemExit(0)

ws_id = layout.get("workspace_id")
tab_id = layout.get("tab_id")
zoomed = bool(layout.get("zoomed"))
focused_pane = layout.get("focused_pane_id")

ws = next((w for w in workspaces if w.get("workspace_id") == ws_id), None)
if ws is None:
    raise SystemExit(0)

# Background workspace -> herdr's built-in already notifies. Leave it alone.
if not ws.get("focused"):
    raise SystemExit(0)

active_tab = ws.get("active_tab_id")
# Visible = on the active tab AND (not zoomed, or *we* are the zoomed pane).
visible = (tab_id == active_tab) and (not zoomed or focused_pane == pane)
if visible:
    raise SystemExit(0)

subprocess.run(
    [
        "herdr", "notification", "show", "Claude done",
        "--body", "The agent finished in a hidden pane",
        "--sound", "done",
    ],
    check=False,
)
PY
