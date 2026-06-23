-- Hide LazyVim's "<leader>q" quit/session which-key group. Its only mapping
-- (<leader>qq) is removed in lua/config/keymaps.lua, and <leader>q is repurposed
-- (buffer-local) to open the current note in Quartz inside the vault
-- (lua/config/quartz.lua).
return {
  "folke/which-key.nvim",
  opts = {
    spec = {
      { "<leader>q", group = "quit/session", hidden = true },
    },
  },
}
