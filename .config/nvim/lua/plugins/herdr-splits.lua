-- Seamless directional navigation + resizing between Neovim splits and herdr
-- panes (the herdr port of smart-splits.nvim / vim-tmux-navigator).
--
-- Only loads inside a herdr-managed pane (HERDR_ENV=1); outside herdr the
-- tmux-navigator.lua spec handles ctrl+h/j/k/l instead. The herdr side is a
-- plugin whose nav-*/resize-* actions are bound to ctrl+ / alt+ h/j/k/l in
-- ~/.config/herdr/config.toml — install/update it with:
--   herdr plugin install lmilojevicc/herdr-splits.nvim
return {
  "lmilojevicc/herdr-splits.nvim",
  cond = vim.env.HERDR_ENV == "1",
  event = "VeryLazy",
  config = function()
    require("herdr-splits").setup({
      -- Defaults are sensible; at_edge = "wrap" matches tmux-navigator feel.
      at_edge = "wrap",
    })
  end,
  keys = {
    { "<C-h>", function() require("herdr-splits").move_cursor_left() end, desc = "Navigate left" },
    { "<C-j>", function() require("herdr-splits").move_cursor_down() end, desc = "Navigate down" },
    { "<C-k>", function() require("herdr-splits").move_cursor_up() end, desc = "Navigate up" },
    { "<C-l>", function() require("herdr-splits").move_cursor_right() end, desc = "Navigate right" },
    { "<M-h>", function() require("herdr-splits").resize_left() end, desc = "Resize left" },
    { "<M-j>", function() require("herdr-splits").resize_down() end, desc = "Resize down" },
    { "<M-k>", function() require("herdr-splits").resize_up() end, desc = "Resize up" },
    { "<M-l>", function() require("herdr-splits").resize_right() end, desc = "Resize right" },
  },
}
