return {
  "supermaven-inc/supermaven-nvim",
  enabled = false, -- Disabled to fix TUI crashes
  config = function()
    require("supermaven-nvim").setup({})
  end,
}
