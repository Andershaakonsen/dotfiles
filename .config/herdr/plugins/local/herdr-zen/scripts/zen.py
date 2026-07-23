#!/usr/bin/env python3
"""herdr-zen — distraction-free "zen mode" toggle for herdr.

herdr (as of 0.7.4) has no built-in zen mode and no runtime API for the [ui]
settings that make one: pane_borders, pane_gaps, and
hide_tab_bar_when_single_tab are config-only. The one supported path is to
rewrite config.toml and hot-reload the server ("Reload applies most UI
settings without restarting panes"). This plugin does exactly that:

  toggle / on / off   rewrite the herdr-zen managed block in config.toml's
                      [ui] section, then run `herdr server reload-config`.

Zen on:  pane_gaps=false, hide_tab_bar_when_single_tab=true. pane_borders
stays true in both states — splits keep their border line, zen only removes
the padding around panes.
Zen off: the defaults (true / true / false).

The config file itself is the state — zen is "on" iff the managed block says
pane_gaps = false — so there is no separate state file to drift.

The sidebar is deliberately NOT handled here: its collapse state is internal
client state with no CLI/socket method to flip it. Use herdr's built-in
toggle_sidebar binding (prefix+b, with ui.sidebar_collapsed_mode = "hidden")
alongside prefix+z.
"""

import json
import os
import re
import socket
import subprocess
import sys

BEGIN_MARK = "# --- herdr-zen begin"
END_MARK = "# --- herdr-zen end"

# key -> (zen-on value, zen-off value)
KEYS = {
    "pane_borders": ("true", "true"),  # borders stay on — zen only drops the gaps
    "pane_gaps": ("false", "true"),
    "hide_tab_bar_when_single_tab": ("true", "false"),
}


def config_path():
    """The live config file, symlinks resolved — the user's config.toml is a
    symlink into a dotfiles repo, and replacing the symlink itself would
    detach it from the repo."""
    path = os.environ.get("HERDR_CONFIG_PATH") or os.path.join(
        os.path.expanduser("~"), ".config", "herdr", "config.toml"
    )
    return os.path.realpath(path)


def notify(body):
    """Best-effort toast over herdr's unix socket (same pattern as
    herdr-lastws); zen must still work if notifications fail."""
    path = os.environ.get("HERDR_SOCKET_PATH")
    if not path:
        return
    req = json.dumps(
        {
            "id": "zen",
            "method": "notification.show",
            "params": {"title": "Zen mode", "body": body},
        }
    ) + "\n"
    try:
        with socket.socket(socket.AF_UNIX, socket.SOCK_STREAM) as s:
            s.settimeout(3)
            s.connect(path)
            s.sendall(req.encode())
    except Exception:
        pass


def fail(msg):
    notify(msg)
    print(f"herdr-zen: {msg}", file=sys.stderr)
    sys.exit(1)


def split_block(text):
    """Return (head, block, tail) around the managed block, or fail."""
    begin = text.find(BEGIN_MARK)
    end = text.find(END_MARK)
    if begin == -1 or end == -1 or end < begin:
        fail("managed block missing in config.toml — see plugins/local/herdr-zen")
    end = text.index("\n", end) + 1 if "\n" in text[end:] else len(text)
    return text[:begin], text[begin:end], text[end:]


def zen_is_on(block):
    m = re.search(r"^pane_gaps\s*=\s*(true|false)\s*$", block, re.M)
    if not m:
        fail("pane_gaps not found in the herdr-zen managed block")
    return m.group(1) == "false"


def rewrite(block, zen_on):
    for key, (on_val, off_val) in KEYS.items():
        val = on_val if zen_on else off_val
        block, n = re.subn(
            rf"^{key}\s*=.*$", f"{key} = {val}", block, count=1, flags=re.M
        )
        if n != 1:
            fail(f"{key} not found in the herdr-zen managed block")
    return block


def write_config(path, text):
    """Atomic replace next to the real file, preserving its mode."""
    tmp = path + ".herdr-zen.tmp"
    mode = os.stat(path).st_mode
    with open(tmp, "w") as f:
        f.write(text)
    os.chmod(tmp, mode)
    os.replace(tmp, path)


def reload_config():
    herdr = os.environ.get("HERDR_BIN_PATH") or "herdr"
    res = subprocess.run(
        [herdr, "server", "reload-config"], capture_output=True, text=True
    )
    if res.returncode != 0:
        fail(f"reload-config failed: {res.stderr.strip() or res.stdout.strip()}")


def main():
    cmd = sys.argv[1] if len(sys.argv) > 1 else "toggle"
    if cmd not in ("toggle", "on", "off"):
        print(f"unknown command: {cmd}", file=sys.stderr)
        sys.exit(2)

    path = config_path()
    try:
        with open(path) as f:
            text = f.read()
    except OSError as e:
        fail(f"cannot read config: {e}")

    head, block, tail = split_block(text)
    target = {"toggle": not zen_is_on(block), "on": True, "off": False}[cmd]
    write_config(path, head + rewrite(block, target) + tail)
    reload_config()
    notify("on — prefix+b hides the sidebar" if target else "off")


if __name__ == "__main__":
    main()
