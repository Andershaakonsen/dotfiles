-- Extra colorschemes to trial via the <leader>uC picker (see snacks.lua).
-- These are mid-contrast, warm dark themes that read well in a bright room
-- (not washed-out-dark, not full light). Both also ship light variants that
-- follow `vim.o.background`.
--
-- lazy = false so their `colors/` dirs are on runtimepath at startup and the
-- schemes actually show up in Telescope's colorscheme picker. Default priority
-- (below tokyonight's 1000) so the real startup theme in colorscheme.lua still
-- wins — these only take over when explicitly picked.
return {
  {
    "sainnhe/gruvbox-material",
    lazy = false,
    init = function()
      vim.g.gruvbox_material_background = "medium" -- soft | medium | hard
      vim.g.gruvbox_material_foreground = "material" -- material | mix | original
      vim.g.gruvbox_material_better_performance = 1
    end,
  },
  {
    "sainnhe/everforest",
    lazy = false,
    init = function()
      vim.g.everforest_background = "medium" -- soft | medium | hard
      vim.g.everforest_better_performance = 1
    end,
  },
}
