return {
  "saghen/blink.cmp",
  enabled = true, -- Re-enabled with minimal safe config
  opts = {
    -- Don't run blink inside the Telescope prompt; otherwise its completion
    -- menu hijacks <C-j>/<C-k> from Telescope's own selection movement.
    enabled = function()
      return vim.bo.filetype ~= "TelescopePrompt"
    end,
    keymap = {
      preset = "default",
      -- Use Ctrl+j/k for navigation (Tab is for Supermaven)
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
      ["<C-space>"] = { "show", "fallback" },
    },
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
    },
    sources = {
      default = { "lsp", "path", "buffer" }, -- Removed snippets to avoid crashes
    },
    completion = {
      menu = {
        draw = {
          treesitter = { "lsp" }, -- Minimal treesitter usage
        },
      },
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
      },
    },
  },
}
