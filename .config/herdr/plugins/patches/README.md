# herdr-plus local patches

Patches applied to the third-party [`cloudmanic/herdr-plus`](https://github.com/cloudmanic/herdr-plus)
plugin. The plugin itself is **not** version-controlled here — herdr installs it
into a managed path (`~/.config/herdr/plugins/github/cloudmanic.herdr-plus-<hash>/`),
which gets overwritten on plugin update/reinstall. These patches capture the
local changes so they can be reapplied and rebuilt after an update.

## `cloudmanic.herdr-plus-sessionizer.patch`

**What it does:** makes the "Herdr Plus: Projects" action (bound to `prefix+f`)
behave like tmux-sessionizer. Opening a project whose workspace is *already open*
now **switches to it** instead of spinning up a duplicate workspace.

**How:** `openProject()` (in `projects.go`) now calls `workspace.list` first and,
if an open workspace's label matches the project name, calls `workspace.focus`
and returns — otherwise it creates a fresh workspace as before. Two thin socket
helpers (`workspaceList`, `workspaceFocus`) were added to `herdr.go`.

- Based on upstream commit `f32b0825f12543c1d03e54fb10d1741c40d66cdc` (v0.1.16).
- The match is by workspace **label**, which the plugin sets to the project's
  `name`. So a project's `name` is what identifies "already open" — keep names
  unique per project.
- Failing open: if `workspace.list` errors, it falls back to always-create.

## Reapplying after a plugin update

```sh
# 1. Find the managed plugin dir (hash changes per install):
PLUGIN_DIR=$(python3 -c "import json,glob; print(json.load(open(glob.glob('$HOME/.config/herdr/plugins.json')[0]))[0]['plugin_root'])")

# 2. Apply the patch (from this directory):
git -C "$PLUGIN_DIR" apply "$PWD/cloudmanic.herdr-plus-sessionizer.patch"
#   …or, if the tree isn't a git checkout: patch -p1 -d "$PLUGIN_DIR" < cloudmanic.herdr-plus-sessionizer.patch

# 3. Rebuild the binary (same as the plugin's own scripts/build.sh):
( cd "$PLUGIN_DIR" && go build -o bin/herdr-plus . )

# 4. Restart herdr so it reloads the plugin binary.
```

Requires a Go toolchain (`brew install go`). If the patch no longer applies
cleanly against a newer upstream, reproduce the change by hand — it's ~15 lines,
described above.
