# herdr-lastws

A tmux-style **"last workspace" (MRU) toggle** for herdr. Bound to `prefix+l`,
it jumps to the workspace you were most recently on; press it again to toggle
straight back — exactly like tmux's `prefix+L` (`switch-client -l`).

## Why

herdr ships only *ordinal* workspace navigation (`previous_workspace` /
`next_workspace` move by workspace number), not a *last-visited* jump. This
plugin adds the MRU behavior.

## How it works

- **Event hook** on `workspace.focused` (`scripts/lastws.py on-focus`): herdr
  invokes it on every workspace focus. It keeps a 2-deep MRU stack — `current`
  and `previous` — in a per-session state file
  (`$XDG_STATE_HOME/herdr-lastws/<session>.json`, default
  `~/.local/state/herdr-lastws/`). No daemon; herdr drives the hook.
- **Action** `last` (`scripts/lastws.py jump`, bound to `prefix+l`): focuses
  `previous`. Because that focus is itself a `workspace.focused` event, the hook
  swaps `current`/`previous`, so repeated presses toggle back and forth.

State is namespaced by `HERDR_SESSION` so parallel sessions don't clobber each
other. A missing/closed previous workspace is a no-op (with a toast).

Set `HERDR_LASTWS_DEBUG=1` in the environment to log resolved focus/jump
decisions and the raw event payload to `.../herdr-lastws/debug.log`.

## Install (not captured by version control)

herdr records linked local plugins in `~/.config/herdr/plugins.json`, which
lives outside this repo — so on a fresh machine, re-link:

```sh
herdr plugin link ~/dotfiles/.config/herdr/plugins/local/herdr-lastws
herdr server reload-config
```

The `prefix+l` keybinding itself lives in `config.toml` (version-controlled):

```toml
[[keys.command]]
key = "prefix+l"
type = "plugin_action"
command = "herdr-lastws.last"
```

To remove: `herdr plugin unlink herdr-lastws` and drop the keybinding.
