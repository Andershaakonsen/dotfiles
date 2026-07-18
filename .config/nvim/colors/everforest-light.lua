-- Pickable "everforest-light" entry for the <leader>uC picker.
--
-- Everforest has no separate light scheme: `:colorscheme everforest` renders
-- light or dark purely from `vim.o.background`. This shim is a real colorscheme
-- file (so it shows up as its own entry in Telescope's colorscheme picker) that
-- forces the light + medium variant, then hands off to everforest proper.
vim.o.background = "light"
vim.g.everforest_background = "medium" -- soft | medium | hard
vim.g.everforest_better_performance = 1
vim.cmd.colorscheme("everforest")
