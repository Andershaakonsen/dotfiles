-- Disable ALL completion to fix crashes
return {
  -- Disable LazyVim's default completion
  { "hrsh7th/nvim-cmp", enabled = false },
  { "saghen/blink.cmp", enabled = false },
  { "supermaven-inc/supermaven-nvim", enabled = false },
  { "zbirenbaum/copilot.lua", enabled = false },

  -- Disable snippets that trigger completion
  { "L3MON4D3/LuaSnip", enabled = false },
  { "rafamadriz/friendly-snippets", enabled = false },
}
