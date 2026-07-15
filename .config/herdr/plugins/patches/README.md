# herdr-plus local patches

Patches applied to the third-party [`cloudmanic/herdr-plus`](https://github.com/cloudmanic/herdr-plus)
plugin. The plugin itself is **not** version-controlled here — herdr installs it
into a managed path (`~/.config/herdr/plugins/github/cloudmanic.herdr-plus-<hash>/`),
which gets overwritten on plugin update/reinstall. `cloudmanic.herdr-plus.patch`
captures the local changes so they can be reapplied and rebuilt after an update.

Based on upstream commit `f32b0825f12543c1d03e54fb10d1741c40d66cdc` (v0.1.16).
The patch bundles the two changes below.

## 1. Sessionizer behavior

**What it does:** makes the "Herdr Plus: Projects" action (bound to `prefix+f`)
behave like tmux-sessionizer. Opening a project whose workspace is *already open*
now **switches to it** instead of spinning up a duplicate workspace.

**How:** `openProject()` (in `projects.go`) calls `workspace.list` first and, if
an open workspace's label matches the project name, calls `workspace.focus` and
returns — otherwise it creates a fresh workspace as before. Two thin socket
helpers (`workspaceList`, `workspaceFocus`) were added to `herdr.go`.

- The match is by workspace **label**, which the plugin sets to the project's
  `name`. So a project's `name` is what identifies "already open" — keep names
  unique per project.
- Failing open: if `workspace.list` errors, it falls back to always-create.

## 2. Keep zoom through the picker (tab placement)

**What it does:** keeps a zoomed pane zoomed through `prefix+f`, with no flicker
— whether you switch to another project or stay. Without this, opening the
Projects picker while a pane is zoomed lands you un-zoomed.

**Why:** herdr's default picker placement (`zoomed`, in `herdr-plugin.toml`)
opens the picker as a plugin pane *in the caller's tab*. Tearing that pane down
makes herdr recompute the tab layout and **drop the tab's zoom** (verified for
both `zoomed` and `overlay` placement — both live in the caller's tab). Since
`herdr pane zoom` has **no `--no-focus`** (confirmed in the CLI and the
`pane.zoom` socket method), you cannot re-zoom the caller pane afterward without
also stealing focus onto it — which is what produced the bounce/flicker in the
earlier watcher-based approach.

**How:** `launchProjects()` (in `projects.go`) opens the picker with
`--placement tab` instead of `zoomed`, so the picker lives in its **own tab**.
The caller's tab is never touched, so its zoom is never lost — no restore is
needed at all. Verified empirically against herdr 0.7.1 via the socket API:
with `--placement tab`, the origin tab's `zoomed` flag stays `true` through the
picker opening and closing, and closing the picker tab returns focus to the
origin (zoomed) tab.

- This replaced an earlier approach (a detached `restore-zoom` watcher in a
  `zoomrestore.go` file, dispatched from `main.go`) that re-zoomed the caller
  pane after the picker closed. That worked but flickered, because re-zooming
  always steals focus. The tab-placement fix removes all of it — `main.go` is
  back to upstream and `zoomrestore.go` is gone.
- Trade-off: the picker now shows as its own tab (a brief entry in the tab bar)
  rather than a zoomed pane in the current tab. Both are full-screen while open.

**Landing on the right tab.** A tab-placed picker is appended as the last tab
and becomes active. herdr's *plugin-pane* teardown then activates the picker
tab's **neighbor** (not the tab you launched from) — unlike a normal `tab close`,
which returns to the previously-active tab. So a switch-and-return (or even a
stay) would land on the wrong tab. Fix: `launchProjects()` passes the launching
tab id to the picker via `--env HERDR_PLUS_LAUNCH_TAB=<tab_id>` (the only place
the launcher's context is available — the picker pane's own context is the
picker). `runProjectsUI()` then calls `tab.focus` on that tab *before* it exits
(and before `openProject`'s workspace switch), via the new `tabFocus` helper in
`herdr.go`. Verified against herdr 0.7.1: with the env set, cancelling the picker
lands on the launching tab; without it, on the neighbor. Order matters — doing it
before the switch means: switch → you leave for the target and the origin keeps
the right active tab; stay/cancel → you land back on the launching tab.

## Reapplying after a plugin update

```sh
# 1. Find the managed plugin dir (hash changes per install):
PLUGIN_DIR=$(python3 -c "import json,glob; print(json.load(open(glob.glob('$HOME/.config/herdr/plugins.json')[0]))[0]['plugin_root'])")

# 2. Apply the patch (from this directory):
git -C "$PLUGIN_DIR" apply "$PWD/cloudmanic.herdr-plus.patch"
#   …or, if the tree isn't a git checkout: patch -p1 -d "$PLUGIN_DIR" < cloudmanic.herdr-plus.patch

# 3. Rebuild the binary (same as the plugin's own scripts/build.sh):
( cd "$PLUGIN_DIR" && go build -o bin/herdr-plus . )

# 4. Restart herdr so it reloads the plugin binary.
```

Requires a Go toolchain (`brew install go`). If the patch no longer applies
cleanly against a newer upstream, reproduce the changes by hand — they're small
and described above.
