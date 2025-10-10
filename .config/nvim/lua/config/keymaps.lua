-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local map = LazyVim.safe_keymap_set

-- Tmux navigator
map({ "n", "" }, "<C-h>", ":TmuxNavigateLeft<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-l>", ":TmuxNavigateRight<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-j>", ":TmuxNavigateDown<cr>", { silent = true, noremap = true })
map({ "n", "" }, "<C-k>", ":TmuxNavigateUp<cr>", { silent = true, noremap = true })

vim.keymap.set("n", "<leader>as", function()
  vim.fn.system("open -a Obsidian")
  vim.defer_fn(function()
    -- Bytt ut med din valgte hotkey
    vim.fn.system('osascript -e \'tell application "System Events" to keystroke "a" using {command down, shift down}\'')
    -- Venter litt, så åpner Anki og synker
    vim.defer_fn(function()
      vim.fn.system("open -a Anki")
      vim.defer_fn(function()
        -- Anki sync hotkey (standard er 'y' eller Cmd+Shift+S)
        vim.fn.system('osascript -e \'tell application "System Events" to keystroke "y"\'')
        -- Hopp tilbake til Kitty
        vim.defer_fn(function()
          vim.fn.system("open -a Kitty")
          -- Refresh buffer i Neovim
          vim.defer_fn(function()
            vim.cmd("edit")
          end, 100)
        end, 1000)
      end, 500)
    end, 1000)
  end, 400)
end, { desc = "Anki Scan Vault & Sync" })

-- Legg til i lua/config/keymaps.lua
-- vim.keymap.set("n", "<leader>as", function()
--   local script = [[
--       tell application "Obsidian"
--         activate
--       end tell
--       delay 1
--       tell application "System Events"
--         tell process "Obsidian"
--           keystroke "p" using {command down, shift down}
--           delay 1
--           type "Scan Vault"
--           delay 0.5
--           key code 36
--         end tell
--       end tell
--     ]]
--   vim.fn.system("osascript -e '" .. script .. "'")
-- end, { desc = "Anki Scan Vault" })

-- vim.keymap.set("n", "<leader>as", function()
--   local vault_name = "satoru" -- Bytt ut med ditt vault
-- navn
--   local uri = string.format("obsidian://advanced-uri?vault=%s&com
-- mandid=obsidian-to-anki-plugin%%3Ascan-vault", vault_name)
--   vim.fn.system("open '" .. uri .. "'")
--   print("Anki scan triggered...")
-- end, { desc = "Anki Scan Vault" })

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

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<cr>", { desc = "Find File" })
map("n", "<leader>fs", ":Telescope live_grep<cr>", { desc = "Find String" })

-- Search
map("n", "<esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<C-c>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Snacks notifications
map("n", "<leader>nc", function()
  Snacks.notifier.hide()
end, { desc = "Clear notifications" })

-- Markdown image toggle
local image_enabled = true
map("n", "<leader>mi", function()
  local ok, image = pcall(require, "image")
  if not ok then
    print("Image.nvim not loaded")
    return
  end

  if image_enabled then
    image.clear()
    vim.g.image_nvim_enabled = false
    image_enabled = false
    print("Image.nvim disabled")
  else
    vim.g.image_nvim_enabled = true
    image_enabled = true
    -- Refresh current buffer to show images
    vim.cmd("edit")
    print("Image.nvim enabled")
  end
end, { desc = "Markdown + Image toggle" })

