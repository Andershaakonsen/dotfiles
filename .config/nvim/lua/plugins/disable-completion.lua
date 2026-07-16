-- Disable problematic completion engines
return {
  -- Disable old nvim-cmp (use blink.cmp instead)
  -- { "hrsh7th/nvim-cmp", enabled = false },

  -- blink.cmp is enabled in blink.lua with safe config

  -- Disable AI completion (can cause TUI issues)
  { "zbirenbaum/copilot.lua", enabled = false },

  -- Disable snippets that trigger completion
  -- { "L3MON4D3/LuaSnip", enabled = tru },
  -- { "rafamadriz/friendly-snippets", enabled = true },
}
