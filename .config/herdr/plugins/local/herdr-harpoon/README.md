# herdr-harpoon

Harpoon-style workspace marks for [herdr](https://herdr.dev), inspired by
[ThePrimeagen's harpoon](https://github.com/ThePrimeagen/harpoon): keep a small,
curated, ordered list of your key workspaces and jump to them by index with a
single chord — instead of hunting through the sidebar or cycling `previous/next`.

A local plugin, linked in place from this repo (`herdr plugin link`), so edits
here are live.

## Keys (bound in `~/.config/herdr/config.toml`)

| Key | Action |
|-----|--------|
| `prefix + a` | Mark the current workspace (append to the list) |
| `prefix + 1..5` | Jump to mark 1..5 |
| `prefix + A` | Open the editable marks list (reorder/delete lines in nvim, save) |

`prefix + 1..5` replaces herdr's default numbered `switch_tab`; sequential tab
switching is still on `prefix + n` / `prefix + p`.

## How it works

herdr's API has no "focus this exact pane by id" — only `pane.focus_direction`
— but it does have `workspace.focus`. So marks are workspace **labels**, not
pane/tab ids. Labels (`dotfiles`, `zsh`, `reel`, …) are stable across herdr
restarts and pane recreation, and are matched against the live `workspace.list`
at jump time. If a marked workspace isn't currently open, the jump just shows a
notification instead of failing.

- `scripts/harpoon.py` talks to herdr over its unix socket (`HERDR_SOCKET_PATH`),
  newline-delimited JSON — no extra dependencies beyond `python3`.
- Marks live in `${XDG_STATE_HOME:-~/.local/state}/herdr-harpoon/marks`, one
  label per line. It's runtime state (not version-controlled). The `prefix + A`
  menu just opens that file in the editor; reorder or delete lines and save.
- Feedback (marked / already-marked / not-open) is delivered via herdr toasts
  (`notification.show`).

## Install / relink

```sh
herdr plugin link ~/dotfiles/.config/herdr/plugins/local/herdr-harpoon
herdr server reload-config
```

## Limitations / ideas

- **Workspace granularity.** Jumps land on a workspace, not a specific pane/tab
  (the API can't focus an arbitrary pane by id). Tab-level marks via `tab.focus`
  would be a possible finer-grained variant.
- Duplicate workspace labels resolve to the first match.
