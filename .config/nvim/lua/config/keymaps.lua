-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- Tmux navigator
map({ "n", "" }, "<C-h>", ":TmuxNavigateLeft<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-l>", ":TmuxNavigateRight<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-j>", ":TmuxNavigateDown<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-k>", ":TmuxNavigateUp<cr>", { silent = true, noremap = true })

-- Navigate in insert mode
map("i", "<C-k>", "<Up>", { desc = "Move cursor up in insert mode" })
map("i", "<C-j>", "<Down>", { desc = "Move cursor down in insert mode" })
map("i", "<C-h>", "<Left>", { desc = "Move cursor left in insert mode" })
map("i", "<C-l>", "<Right>", { desc = "Move cursor right in insert mode" })

-- Keep cursor centered when jumping
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up and center" })
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down and center" })

-- Window management
map("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Make split windows equal width & height" })
map("n", "<leader>sx", ":close<CR>", { desc = "Close current split window" })
map("n", "<leader>sm", ":MaximizerToggle<CR>", { desc = "Toggle split window maximization" })

-- Quick save all files
map("n", "<leader>w", "<cmd>wa<cr>", { desc = "Save all files", silent = false })

-- Harpoon
map("n", "<leader>1", ":lua require('harpoon.ui').nav_file(1)<cr>", { desc = "Harpoon: Jump to file 1" })
map("n", "<leader>2", ":lua require('harpoon.ui').nav_file(2)<cr>", { desc = "Harpoon: Jump to file 2" })
map("n", "<leader>3", ":lua require('harpoon.ui').nav_file(3)<cr>", { desc = "Harpoon: Jump to file 3" })
map("n", "<leader>4", ":lua require('harpoon.ui').nav_file(4)<cr>", { desc = "Harpoon: Jump to file 4" })
map("n", "<leader>5", ":lua require('harpoon.ui').nav_file(5)<cr>", { desc = "Harpoon: Jump to file 5" })

map("n", "<C-e>", "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>", { desc = "Harpoon: Toggle quick menu" })
map(
  "n",
  "<leader>a",
  "<cmd>lua require('harpoon.mark').add_file()<cr>",
  { desc = "Harpoon: Add current file to harpoon" }
)
