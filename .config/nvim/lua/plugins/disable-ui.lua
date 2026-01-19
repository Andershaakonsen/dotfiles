-- Temporarily disable UI plugins that may cause TUI race conditions
return {
  -- Disable UI-heavy plugins
  { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  { "stevearc/dressing.nvim", enabled = false },

  -- Keep treesitter but with minimal config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = { enable = false }, -- Disable highlights to test
      indent = { enable = false },
    },
  },
}
