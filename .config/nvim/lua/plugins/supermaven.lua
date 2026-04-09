return {
  "supermaven-inc/supermaven-nvim",
  enabled = true, -- Re-enabled for AI completion
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<Tab>", -- Tab accepts Supermaven suggestions
        clear_suggestion = "<C-]>",
        accept_word = "<C-l>", -- Changed to Ctrl+l (Ctrl+j/k used for dropdown)
      },
      ignore_filetypes = {}, -- Enable for all filetypes
      color = {
        suggestion_color = "#808080",
        cterm = 244,
      },
      log_level = "info",
      disable_inline_completion = false, -- Keep inline suggestions
      disable_keymaps = false,
    })
  end,
}
