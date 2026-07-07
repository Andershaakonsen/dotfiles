-- Plugin that will allow you to navigate seamlessly between
-- vim and tmux splits using a consistent set of hotkeys.
--
-- Disabled inside herdr (HERDR_ENV=1) — there, herdr-splits.lua owns
-- ctrl+h/j/k/l so the two don't both map the same keys. This still loads for
-- plain tmux sessions.
return {
  "christoomey/vim-tmux-navigator",
  cond = vim.env.HERDR_ENV ~= "1",
}
