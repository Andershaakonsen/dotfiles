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
-- Keymaps for Telescope are defined in lua/plugins/telescope.lua

-- Search
map("n", "<esc>", ":nohlsearch<CR>", { desc = "Clear search highlights" })
map("n", "<C-c>", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- Snacks notifications (disabled)
-- map("n", "<leader>nc", function()
--   Snacks.notifier.hide()
-- end, { desc = "Clear notifications" })

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

-------------------------------------------------------------------------------
--                           Folding section
-------------------------------------------------------------------------------

-- Checks each line to see if it matches a markdown heading (#, ##, etc.):
-- It’s called implicitly by Neovim’s folding engine by vim.opt_local.foldexpr
function _G.markdown_foldexpr()
  local lnum = vim.v.lnum
  local line = vim.fn.getline(lnum)
  local heading = line:match("^(#+)%s")
  if heading then
    local level = #heading
    if level == 1 then
      -- Special handling for H1
      if lnum == 1 then
        return ">1"
      else
        local frontmatter_end = vim.b.frontmatter_end
        if frontmatter_end and (lnum == frontmatter_end + 1) then
          return ">1"
        end
      end
    elseif level >= 2 and level <= 6 then
      -- Regular handling for H2-H6
      return ">" .. level
    end
  end
  return "="
end

local function set_markdown_folding()
  vim.opt_local.foldmethod = "expr"
  vim.opt_local.foldexpr = "v:lua.markdown_foldexpr()"
  vim.opt_local.foldlevel = 99

  -- Detect frontmatter closing line
  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local found_first = false
  local frontmatter_end = nil
  for i, line in ipairs(lines) do
    if line == "---" then
      if not found_first then
        found_first = true
      else
        frontmatter_end = i
        break
      end
    end
  end
  vim.b.frontmatter_end = frontmatter_end
end

-- Use autocommand to apply only to markdown files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = set_markdown_folding,
})

-- Function to fold all headings of a specific level
local function fold_headings_of_level(level)
  -- Move to the top of the file without adding to jumplist
  vim.cmd("keepjumps normal! gg")
  -- Get the total number of lines
  local total_lines = vim.fn.line("$")
  for line = 1, total_lines do
    -- Get the content of the current line
    local line_content = vim.fn.getline(line)
    -- "^" -> Ensures the match is at the start of the line
    -- string.rep("#", level) -> Creates a string with 'level' number of "#" characters
    -- "%s" -> Matches any whitespace character after the "#" characters
    -- So this will match `## `, `### `, `#### ` for example, which are markdown headings
    if line_content:match("^" .. string.rep("#", level) .. "%s") then
      -- Move the cursor to the current line without adding to jumplist
      vim.cmd(string.format("keepjumps call cursor(%d, 1)", line))
      -- Check if the current line has a fold level > 0
      local current_foldlevel = vim.fn.foldlevel(line)
      if current_foldlevel > 0 then
        -- Fold the heading if it matches the level
        if vim.fn.foldclosed(line) == -1 then
          vim.cmd("normal! za")
        end
        -- else
        --   vim.notify("No fold at line " .. line, vim.log.levels.WARN)
      end
    end
  end
end

local function fold_markdown_headings(levels)
  -- I save the view to know where to jump back after folding
  local saved_view = vim.fn.winsaveview()
  for _, level in ipairs(levels) do
    fold_headings_of_level(level)
  end
  vim.cmd("nohlsearch")
  -- Restore the view to jump to where I was
  vim.fn.winrestview(saved_view)
end

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 1 or above
vim.keymap.set("n", "zj", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfj", function()
  -- Reloads the file to refresh folds, otheriise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2, 1 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 1 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 2 or above
-- I know, it reads like "madafaka" but "k" for me means "2"
vim.keymap.set("n", "zk", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfk", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3, 2 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 3 or above
vim.keymap.set("n", "zl", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfl", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4, 3 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 3 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for folding markdown headings of level 4 or above
vim.keymap.set("n", "z;", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mf;", function()
  -- Reloads the file to refresh folds, otherwise you have to re-open neovim
  vim.cmd("edit!")
  -- Unfold everything first or I had issues
  vim.cmd("normal! zR")
  fold_markdown_headings({ 6, 5, 4 })
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold all headings level 4 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Use <CR> to fold when in normal mode
-- To see help about folds use `:help fold`
vim.keymap.set("n", "<CR>", function()
  -- Get the current line number
  local line = vim.fn.line(".")
  -- Get the fold level of the current line
  local foldlevel = vim.fn.foldlevel(line)
  if foldlevel == 0 then
    vim.notify("No fold found", vim.log.levels.INFO)
  else
    vim.cmd("normal! za")
    vim.cmd("normal! zz") -- center the cursor line on screen
  end
end, { desc = "[P]Toggle fold" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- Keymap for unfolding markdown headings of level 2 or above
-- Changed all the markdown folding and unfolding keymaps from <leader>mfj to
-- zj, zk, zl, z; and zu respectively lamw25wmal
vim.keymap.set("n", "zu", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- vim.keymap.set("n", "<leader>mfu", function()
  -- Reloads the file to reflect the changes
  vim.cmd("edit!")
  vim.cmd("normal! zR") -- Unfold all headings
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Unfold all headings level 2 or above" })

-- HACK: Fold markdown headings in Neovim with a keymap
-- https://youtu.be/EYczZLNEnIY
--
-- gk jummps to the markdown heading above and then folds it
-- zi by default toggles folding, but I don't need it lamw25wmal
vim.keymap.set("n", "zi", function()
  -- "Update" saves only if the buffer has been modified since the last save
  vim.cmd("silent update")
  -- Difference between normal and normal!
  -- - `normal` executes the command and respects any mappings that might be defined.
  -- - `normal!` executes the command in a "raw" mode, ignoring any mappings.
  vim.cmd("normal gk")
  -- This is to fold the line under the cursor
  vim.cmd("normal! za")
  vim.cmd("normal! zz") -- center the cursor line on screen
end, { desc = "[P]Fold the heading cursor currently on" })
