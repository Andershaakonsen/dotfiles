#!/usr/bin/env python3
"""herdr-lastws — tmux-style "last workspace" toggle for herdr.

herdr only ships ordinal previous/next workspace navigation; it has no
"jump to the workspace I was just on" (MRU) like tmux's prefix+L
(switch-client -l). This plugin adds it:

  on-focus   (event hook on workspace.focused) update a 2-deep MRU stack
             — current + previous — in a per-session state file.
  jump       (action, bind to prefix+l) focus the previous workspace.

Because the jump is itself a focus, it fires workspace.focused again and
on-focus swaps current/previous — so pressing the key repeatedly toggles
back and forth between the two workspaces, exactly like tmux.

State is per herdr session (HERDR_SESSION), so parallel sessions don't
clobber each other's history.
"""

import json
import os
import socket
import sys
import tempfile

SOCKET_ENV = "HERDR_SOCKET_PATH"
DEBUG = os.environ.get("HERDR_LASTWS_DEBUG")


def rpc(method, params=None):
    """One newline-delimited JSON request/response over herdr's unix socket."""
    path = os.environ.get(SOCKET_ENV)
    if not path:
        raise RuntimeError(f"{SOCKET_ENV} not set; not running inside herdr")
    req = json.dumps({"id": "lastws", "method": method, "params": params or {}}) + "\n"
    with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
        s.settimeout(3)
        s.connect(path)
        s.sendall(req.encode())
        buf = b""
        while b"\n" not in buf:
            chunk = s.recv(65536)
            if not chunk:
                break
            buf += chunk
    resp = json.loads(buf.split(b"\n", 1)[0].decode())
    if resp.get("error"):
        raise RuntimeError(resp["error"].get("message", "herdr error"))
    return resp.get("result", {})


def notify(title, body):
    try:
        rpc("notification.show", {"title": title, "body": body})
    except Exception:
        pass


def debug(msg):
    if not DEBUG:
        return
    try:
        with open(os.path.join(state_dir(), "debug.log"), "a") as f:
            f.write(msg.rstrip() + "\n")
    except Exception:
        pass


def state_dir():
    base = os.environ.get("XDG_STATE_HOME") or os.path.join(
        os.path.expanduser("~"), ".local", "state"
    )
    d = os.path.join(base, "herdr-lastws")
    os.makedirs(d, exist_ok=True)
    return d


def state_path():
    session = os.environ.get("HERDR_SESSION") or "default"
    # Keep the filename filesystem-safe regardless of the session name.
    safe = "".join(c if c.isalnum() or c in "-_." else "_" for c in session)
    return os.path.join(state_dir(), f"{safe}.json")


def load_state():
    try:
        with open(state_path()) as f:
            s = json.load(f)
            return s.get("current"), s.get("previous")
    except Exception:
        return None, None


def save_state(current, previous):
    """Atomically write the MRU stack so a concurrent read never sees a partial
    file (the hook can fire in quick succession)."""
    d = state_dir()
    fd, tmp = tempfile.mkstemp(dir=d, suffix=".tmp")
    try:
        with os.fdopen(fd, "w") as f:
            json.dump({"current": current, "previous": previous}, f)
        os.replace(tmp, state_path())
    except Exception:
        try:
            os.unlink(tmp)
        except OSError:
            pass


def focused_workspace_id():
    """The workspace herdr just focused. Prefer the event payload herdr injects
    into the hook; fall back to the live focused workspace if the shape differs
    or we were invoked outside an event."""
    raw = os.environ.get("HERDR_PLUGIN_EVENT_JSON")
    if raw:
        debug(f"event_json={raw}")
        try:
            wid = _find_workspace_id(json.loads(raw))
            if wid:
                return wid
        except Exception as e:
            debug(f"parse_error={e}")
    for w in rpc("workspace.list").get("workspaces", []):
        if w.get("focused"):
            return w.get("workspace_id")
    return None


def _find_workspace_id(obj):
    """Depth-first search for a workspace_id in the event payload, whose exact
    shape isn't documented. The focused-workspace event carries the id at some
    level; we take the first workspace_id we find."""
    if isinstance(obj, dict):
        if isinstance(obj.get("workspace_id"), str):
            return obj["workspace_id"]
        for v in obj.values():
            found = _find_workspace_id(v)
            if found:
                return found
    elif isinstance(obj, list):
        for v in obj:
            found = _find_workspace_id(v)
            if found:
                return found
    return None


def workspace_exists(wid):
    return any(
        w.get("workspace_id") == wid
        for w in rpc("workspace.list").get("workspaces", [])
    )


def cmd_on_focus():
    new = focused_workspace_id()
    if not new:
        debug("on-focus: no focused workspace resolved")
        return
    current, previous = load_state()
    if new == current:
        return  # refocus of the same workspace — nothing moves
    save_state(new, current)
    debug(f"on-focus: current={new} previous={current}")


def cmd_jump():
    current, previous = load_state()
    if not previous:
        notify("Last workspace", "no previous workspace yet")
        return
    if previous == current:
        return
    try:
        if not workspace_exists(previous):
            notify("Last workspace", "previous workspace is gone")
            return
        rpc("workspace.focus", {"workspace_id": previous})
    except Exception as e:
        debug(f"jump error={e}")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else ""
    if cmd == "on-focus":
        cmd_on_focus()
    elif cmd == "jump":
        cmd_jump()
    else:
        print(f"unknown command: {cmd}", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
