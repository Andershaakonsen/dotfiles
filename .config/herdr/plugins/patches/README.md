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

## 2. Zoom restore across the picker

**What it does:** keeps a zoomed pane zoomed through `prefix+f`. Without this,
opening the Projects picker while a pane is zoomed lands you un-zoomed.

**Why:** herdr opens the picker as a plugin pane in the caller's tab and, when it
tears that pane down, recomputes the tab layout and **drops the tab's zoom**.
This was verified to happen with both `placement = "zoomed"` and
`placement = "overlay"`, so it can't be fixed from `herdr-plugin.toml` — it's
herdr-core behavior on picker teardown.

**How:** `launchProjects()` (in `projects.go`) records the launching pane and
whether it was zoomed, opens the picker, then — if it was zoomed — spawns a
detached watcher (`herdr-plus restore-zoom <picker> <caller>`, new file
`zoomrestore.go`, dispatched from `main.go`). The watcher waits for the picker
pane to disappear and re-applies zoom to the caller pane, retrying a few times
to win the race with herdr's teardown-driven unzoom. It runs detached so it
outlives the short-lived action process. All best-effort: any failure leaves the
zoom as-is.

- Restores the caller pane's zoom whether you picked the same project (stay) or
  a different one (the original workspace keeps its zoom for when you return).
- Uses the herdr CLI (`HERDR_BIN_PATH`) for pane queries/zoom, so no extra
  socket plumbing.

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
