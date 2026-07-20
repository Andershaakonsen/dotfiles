return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = {
    -- Noice intercepts LSP hover (K) and signature help and renders them
    -- through its own views, so vim.o.winborder doesn't apply. This preset
    -- puts a rounded border back on those doc popups.
    presets = {
      lsp_doc_border = true,
    },
  },
  dependencies = {
    -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
    "MunifTanjim/nui.nvim",
    -- OPTIONAL:
    --   `nvim-notify` is only needed, if you want to use the notification view.
    --   If not available, we use `mini` as the fallback
    "rcarriga/nvim-notify",
  },
}
