# herdr-zen

Distraction-free **zen mode** toggle for [herdr](https://herdr.dev).

`prefix+z` flips, in one keypress:

- `ui.pane_gaps` → `false` (no padding — splits sit edge-to-edge, separated
  only by the border line; `ui.pane_borders` stays `true` in both states)
- `ui.hide_tab_bar_when_single_tab` → `true` (tab bar disappears on single-tab workspaces)

Press again to restore the defaults.

## How it works

herdr (0.7.4) has no built-in zen mode and no runtime API for these `[ui]`
settings, so the action rewrites a **managed block** in `config.toml` and runs
`herdr server reload-config`, which applies UI settings live. The config file
is the state: zen is on iff the block says `pane_gaps = false`. Side
effect: while zen is on, the (git-tracked) config shows a dirty diff — commit
it in the zen-off state.

The managed block must exist in the `[ui]` section:

```toml
# --- herdr-zen begin ---
pane_borders = true
pane_gaps = true
hide_tab_bar_when_single_tab = false
# --- herdr-zen end ---
```

## What it can't do

- **Sidebar**: collapse state is internal client state — no CLI or socket
  method can flip it (verified against the 0.7.4 CLI, socket API docs, and
  binary). Bind herdr's built-in `toggle_sidebar = "prefix+b"` and set
  `ui.sidebar_collapsed_mode = "hidden"` so `prefix+b` hides it completely.
  Full zen = `prefix+z` then `prefix+b`.
- **Tab bar on multi-tab workspaces**: herdr only supports hiding the tab bar
  when a workspace has a single tab (`hide_tab_bar_when_single_tab`); there is
  no "always hide" option as of 0.7.4.

## Install (fresh machine)

The plugin registry (`~/.config/herdr/plugins.json`) lives outside the
dotfiles repo, so after symlinking the config:

```sh
herdr plugin link ~/dotfiles/.config/herdr/plugins/local/herdr-zen
```

The `prefix+z` binding and the managed block are already in the
version-controlled `config.toml`. Requires herdr >= 0.7.2.

## Actions

| Action | What it does |
|---|---|
| `herdr-zen.toggle` | flip zen mode (bound to `prefix+z`) |
| `herdr-zen.on` / `herdr-zen.off` | force a state (for scripting) |
