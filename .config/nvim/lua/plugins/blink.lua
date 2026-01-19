return {
  "saghen/blink.cmp",
  enabled = false, -- Disabled to fix TUI crashes when typing quotes
  -- If you want to re-enable later with safer settings:
  -- opts = {
  --   keymap = {
  --     preset = "default",
  --   },
  --   appearance = {
  --     use_nvim_cmp_as_default = false,
  --   },
  --   sources = {
  --     default = { "lsp", "path", "snippets", "buffer" },
  --   },
  -- },
}
