-- dressing.nvim — provides the floating `vim.ui.select` menu that LazyVim used
-- to ship by default (newer LazyVim moved this to the Snacks picker, which is
-- disabled here for TUI stability — see snacks.lua). Re-enabled so code actions
-- and other `vim.ui.select` prompts render as a small floating box at the
-- cursor instead of the flat Noice `msg_show.confirm` list at the bottom.
--
-- Scope is deliberately narrow: it takes over `vim.ui.select` ONLY. `vim.ui.input`
-- and the `:` cmdline are left to Noice/native, so nothing else changes.
return {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    -- Lazy-load dressing on first use of vim.ui.select (keeps startup lean).
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select = function(...)
      require("lazy").load({ plugins = { "dressing.nvim" } })
      return vim.ui.select(...)
    end
  end,
  opts = {
    input = { enabled = false }, -- don't touch vim.ui.input / cmdline
    select = {
      backend = { "builtin" }, -- native floating menu (no telescope/fzf dep)
      builtin = {
        relative = "cursor",
        border = "rounded",
        min_width = { 40, 0.2 },
        max_width = { 140, 0.9 },
        min_height = { 1, 0.1 },
      },
    },
  },
}
