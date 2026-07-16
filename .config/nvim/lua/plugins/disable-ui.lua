-- Temporarily disable UI plugins that may cause TUI race conditions
return {
  -- Disable UI-heavy plugins
  -- { "folke/noice.nvim", enabled = false },
  { "rcarriga/nvim-notify", enabled = false },
  -- dressing.nvim is re-enabled in plugins/dressing.lua (it provides the
  -- floating vim.ui.select menu used for code actions).

  -- Keep treesitter but with minimal config
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      -- highlight = { enable = false }, -- Disable highlights to test
      -- indent = { enable = false },
    },
  },
}
