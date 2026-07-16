#!/usr/bin/env python3
"""herdr-harpoon — Harpoon-style workspace marks for herdr.

Inspired by ThePrimeagen's harpoon: keep a small, curated, ordered list of
your key workspaces and jump to them by index with a single chord. herdr's
API has no "focus this exact pane by id", but it does have workspace.focus,
so marks are workspace *labels* — which are stable across restarts and pane
recreation (unlike ephemeral pane ids), and are matched against the live
workspace list at jump time.

Subcommands (invoked by herdr via herdr-plugin.toml):
  add          mark the currently focused workspace
  jump <n>     focus the workspace at mark <n>
  open-menu    open the editable marks list in a herdr pane
  edit         (runs inside that pane) open the marks file in the editor
  list         print the marks (debug)
"""

import json
import os
import socket
import sys

SOCKET_ENV = "HERDR_SOCKET_PATH"

HEADER = (
    "# herdr-harpoon marks — one workspace label per line, in jump order.\n"
    "# prefix+1..5 jump to lines 1..5. Reorder or delete lines to taste;\n"
    "# lines starting with # and blank lines are ignored.\n"
)


def marks_path():
    base = os.environ.get("XDG_STATE_HOME") or os.path.join(
        os.path.expanduser("~"), ".local", "state"
    )
    d = os.path.join(base, "herdr-harpoon")
    os.makedirs(d, exist_ok=True)
    return os.path.join(d, "marks")


def ensure_file():
    p = marks_path()
    if not os.path.exists(p):
        with open(p, "w") as f:
            f.write(HEADER)
    return p


def rpc(method, params=None):
    """One newline-delimited JSON request/response over herdr's unix socket."""
    path = os.environ.get(SOCKET_ENV)
    if not path:
        raise RuntimeError(f"{SOCKET_ENV} not set; not running inside herdr")
    req = json.dumps({"id": "harpoon", "method": method, "params": params or {}}) + "\n"
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


def read_marks():
    with open(ensure_file()) as f:
        return [
            s
            for s in (line.strip() for line in f)
            if s and not s.startswith("#")
        ]


def write_marks(labels):
    with open(marks_path(), "w") as f:
        f.write(HEADER)
        for label in labels:
            f.write(label + "\n")


def focused_label():
    # Prefer the context herdr injects when it fires the action from a keybind.
    raw = os.environ.get("HERDR_PLUGIN_CONTEXT_JSON")
    if raw:
        try:
            label = json.loads(raw).get("workspace_label")
            if label:
                return label
        except Exception:
            pass
    # Fallback: whichever workspace is focused right now.
    for w in rpc("workspace.list").get("workspaces", []):
        if w.get("focused"):
            return w.get("label")
    return None


def cmd_add():
    label = focused_label()
    if not label:
        notify("Harpoon", "could not determine current workspace")
        return
    labels = read_marks()
    if label in labels:
        notify("Harpoon", f"already marked: {label} (#{labels.index(label) + 1})")
        return
    labels.append(label)
    write_marks(labels)
    notify("Harpoon 🎯", f"marked {label} (#{len(labels)})")


def cmd_jump(n):
    labels = read_marks()
    if n < 1 or n > len(labels):
        notify("Harpoon", f"no mark #{n}")
        return
    target = labels[n - 1]
    match = [
        w
        for w in rpc("workspace.list").get("workspaces", [])
        if w.get("label") == target
    ]
    if not match:
        notify("Harpoon", f"#{n} '{target}' not open")
        return
    rpc("workspace.focus", {"workspace_id": match[0]["workspace_id"]})


def cmd_open_menu():
    """Server-side: ask herdr to open the editable marks list as a pane."""
    herdr = os.environ.get("HERDR_BIN_PATH") or "herdr"
    os.execvp(
        herdr,
        [herdr, "plugin", "pane", "open", "--plugin", "herdr-harpoon",
         "--entrypoint", "menu", "--placement", "zoomed"],
    )


def cmd_edit():
    """Runs inside the menu pane: open the marks file in the editor.

    Uses an absolute nvim path (a bare `nvim` is stubbed in this shell) with a
    vi fallback, so reorder/delete-a-line is just normal editing; saving applies.
    """
    p = ensure_file()
    for editor in (os.environ.get("HARPOON_EDITOR"), "/opt/homebrew/bin/nvim", "vi"):
        if editor:
            try:
                os.execvp(editor, [editor, p])
            except FileNotFoundError:
                continue


def cmd_list():
    for i, label in enumerate(read_marks(), 1):
        print(f"{i}. {label}")


def main():
    args = sys.argv[1:]
    cmd = args[0] if args else "list"
    if cmd == "add":
        cmd_add()
    elif cmd == "jump":
        cmd_jump(int(args[1]) if len(args) > 1 and args[1].isdigit() else 0)
    elif cmd == "open-menu":
        cmd_open_menu()
    elif cmd == "edit":
        cmd_edit()
    elif cmd == "list":
        cmd_list()
    else:
        print(f"unknown command: {cmd}", file=sys.stderr)
        sys.exit(2)


if __name__ == "__main__":
    main()
