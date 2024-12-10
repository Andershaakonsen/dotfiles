-- Hello
local nnoremap = require("user.keymap_utils").nnoremap
local vnoremap = require("user.keymap_utils").vnoremap
local inoremap = require("user.keymap_utils").inoremap
local tnoremap = require("user.keymap_utils").tnoremap
local xnoremap = require("user.keymap_utils").xnoremap
local harpoon_ui = require("harpoon.ui")
local harpoon_mark = require("harpoon.mark")
-- local illuminate = require("illuminate")
local utils = require("user.utils")

local M = {}

local TERM = os.getenv("TERM")

-- Normal --
-- Disable Space bar since it'll be used as the leader key
nnoremap("<space>", "<nop>")

-- telescope
nnoremap("<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
nnoremap("<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
nnoremap("<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
nnoremap("<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
nnoremap("<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags
nnoremap("<leader>td", "<cmd>TodoQuickFix<cr>")
nnoremap("<leader>fg", "<cmd>Telescope git_commits<cr>") -- list git files

-- Save with leader key
nnoremap("<leader>w", "<cmd>wa<cr>", { silent = false })
-- nnoremap("<leader>f", ":Format<cr>")
-- Quit with leader key
nnoremap("<leader>q", "<cmd>q<cr>", { silent = false })
-- Save and Quit with leader key
nnoremap("<leader>z", "<cmd>wq<cr>", { silent = false })

nnoremap("<tab>", "<cmd>tabNext<cr>")
nnoremap("tn", "<cmd>tabnew<cr>", { desc = "Tab New" })
nnoremap("tc", "<cmd>tabclose<cr>", { desc = "Tab close" })

--Exit insert mode with jk,kj
inoremap("jk", "<esc>")
inoremap("kj", "<esc>")

-- Harpoon keybinds --
-- Open harpoon ui
nnoremap("<C-e>", function()
	harpoon_ui.toggle_quick_menu()
end)

-- Add current file to harpoon
nnoremap("<leader>a", function()
	harpoon_mark.add_file()
end)

-- Remove current file from harpoon
nnoremap("<leader>hr", function()
	harpoon_mark.rm_file()
end)

-- Move selected lines with shift+j or shift+k
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Remove all files from harpoon
nnoremap("<leader>hc", function()
	harpoon_mark.clear_all()
end)

-- Quickly jump to harpooned files
nnoremap("<leader>1", function()
	harpoon_ui.nav_file(1)
end)

nnoremap("<leader>2", function()
	harpoon_ui.nav_file(2)
end)

nnoremap("<leader>3", function()
	harpoon_ui.nav_file(3)
end)

nnoremap("<leader>4", function()
	harpoon_ui.nav_file(4)
end)

nnoremap("<leader>5", function()
	harpoon_ui.nav_file(5)
end)

-- window management
nnoremap("<leader>sv", "<C-w>v") -- split window vertically
nnoremap("<leader>sh", "<C-w>s") -- split window horizontally
nnoremap("<leader>se", "<C-w>=") -- make split windows equal width & height
nnoremap("<leader>sx", ":close<CR>") -- close current split window
nnoremap("<leader>sm", ":MaximizerToggle<CR>") -- toggle split window maximization

-- nnoremap("<leader>e", function()
--     require("oil").toggle_float()
-- end)

-- Open Spectre for global find/replace
nnoremap("<leader>S", function()
	require("spectre").toggle()
end)

-- Open Spectre for global find/replace for the word under the cursor in normal mode
-- TODO Fix, currently being overriden by Telescope
nnoremap("<leader>sw", function()
	require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word" })

-- Center buffer while navigating
nnoremap("<C-u>", "<C-u>zz")
nnoremap("<C-d>", "<C-d>zz")
nnoremap("{", "{zz")
nnoremap("}", "}zz")
nnoremap("N", "Nzz")
nnoremap("n", "nzz")
nnoremap("G", "Gzz")
nnoremap("gg", "ggzz")
nnoremap("<C-i>", "<C-i>zz")
nnoremap("<C-o>", "<C-o>zz")
nnoremap("%", "%zz")
nnoremap("*", "*zz")
nnoremap("#", "#zz")

-- Press 'H', 'L' to jump to start/end of a line (first/last char)
nnoremap("L", "$")
nnoremap("H", "^")

-- Press 'U' for redo
nnoremap("U", "<C-r>")

-- Turn off highlighted results
nnoremap("<leader>no", "<cmd>noh<cr>")

-- Goto next diagnostic of any severity
nnoremap("]d", function()
	vim.diagnostic.goto_next({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous diagnostic of any severity
nnoremap("[d", function()
	vim.diagnostic.goto_prev({})
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next error diagnostic
nnoremap("]e", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous error diagnostic
nnoremap("[e", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto next warning diagnostic
nnoremap("]w", function()
	vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Goto previous warning diagnostic
nnoremap("[w", function()
	vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
	vim.api.nvim_feedkeys("zz", "n", false)
end)

-- Place all dignostics into a qflist
nnoremap("<leader>ld", vim.diagnostic.setqflist, { desc = "Quickfix [L]ist [D]iagnostics" })

-- Navigate to next qflist item
nnoremap("<leader>cn", ":cnext<cr>zz")

-- Navigate to previos qflist item
-- nnoremap("<leader>cp", ":cprevious<cr>zz")

-- Open the qflist
-- nnoremap("<leader>co", ":copen<cr>zz")

-- Close the qflist
-- nnoremap("<leader>cc", ":cclose<cr>zz")

M.map_lsp_keybinds = function(buffer_number)
	nnoremap("<leader>rn", vim.lsp.buf.rename, { desc = "LSP: [R]e[n]ame", buffer = buffer_number })
	nnoremap("<leader>ca", vim.lsp.buf.code_action, { desc = "LSP: [C]ode [A]ction", buffer = buffer_number })

	-- nnoremap("gd", vim.lsp.buf.definition, { desc = "LSP: [G]oto [D]efinition", buffer = buffer_number })

	-- Telescope LSP keybinds --
	nnoremap(
		"gr",
		require("telescope.builtin").lsp_references,
		{ desc = "LSP: [G]oto [R]eferences", buffer = buffer_number }
	)

	nnoremap(
		"gi",
		require("telescope.builtin").lsp_implementations,
		{ desc = "LSP: [G]oto [I]mplementation", buffer = buffer_number }
	)

	nnoremap(
		"<leader>bs",
		require("telescope.builtin").lsp_document_symbols,
		{ desc = "LSP: [B]uffer [S]ymbols", buffer = buffer_number }
	)

	nnoremap(
		"<leader>ps",
		require("telescope.builtin").lsp_workspace_symbols,
		{ desc = "LSP: [P]roject [S]ymbols", buffer = buffer_number }
	)

	-- See `:help K` for why this keymap
	nnoremap("K", vim.lsp.buf.hover, { desc = "LSP: Hover Documentation", buffer = buffer_number })
	nnoremap("<leader>k", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })
	inoremap("<C-k>", vim.lsp.buf.signature_help, { desc = "LSP: Signature Documentation", buffer = buffer_number })

	-- Lesser used LSP functionality
	nnoremap("gD", vim.lsp.buf.declaration, { desc = "LSP: [G]oto [D]eclaration", buffer = buffer_number })
	nnoremap("td", vim.lsp.buf.type_definition, { desc = "LSP: [T]ype [D]efinition", buffer = buffer_number })
end

-- Paste without losing the contents of the register
xnoremap("<leader>p", '"_dP')

-- Move selected text up/down in visual mode
vnoremap("<A-j>", ":m '>+1<CR>gv=gv")
vnoremap("<A-k>", ":m '<-2<CR>gv=gv")

-- Reselect the last visual selection
xnoremap("<<", function()
	vim.cmd("normal! <<")
	vim.cmd("normal! gv")
end)

xnoremap(">>", function()
	vim.cmd("normal! >>")
	vim.cmd("normal! gv")
end)

-- Terminal --
-- Enter normal mode while in a terminal
tnoremap("<esc>", [[<C-\><C-n>]])
tnoremap("jj", [[<C-\><C-n>]])

nnoremap("<c-h>", ":TmuxNavigateLeft<cr>", { silent = true, noremap = true })
nnoremap("<c-l>", ":TmuxNavigateRight<cr>", { silent = true, noremap = true })
nnoremap("<c-j>", ":TmuxNavigateDown<cr>", { silent = true, noremap = true })
nnoremap("<c-k>", ":TmuxNavigateUp<cr>", { silent = true, noremap = true })

-- save on ctrl s
vim.keymap.set("i", "<C-s>", "<C-c>:update<CR>")
vim.keymap.set("n", "<C-s>", ":update<CR>")

vim.keymap.set("n", "x", '"_x')

-- Navigate in insert mode
vim.keymap.set("i", "<C-k>", "<Up>")
vim.keymap.set("i", "<C-j>", "<Down>")
vim.keymap.set("i", "<C-h>", "<Left>")
vim.keymap.set("i", "<C-l>", "<Right>")

-- vim.api.nvim_set_keymap("n", "<tab>", 'copilot#Accept("<C-n>")', { silent = true, expr = true })
-- vim.api.nvim_set_keymap("i", "<tab>", 'copilot#Accept("<C-n>")', { silent = true, expr = true })

-- local suggestion = require("copilot.suggestion")
--
-- function AcceptCopilotSuggestion()
-- 	if suggestion.is_visible() then
-- 		suggestion.accept()
-- 	else
-- 		vim.cmd("normal! <Tab>")
-- 	end
-- end
-- vim.keymap.set("i", "<C-CR>", "<cmd>lua AcceptCopilotSuggestion()<cr>")

nnoremap("<leader>xx", "<cmd>Trouble diagnostics toggle<cr>")
-- nnoremap("n", "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>")

-- Reenable default <space> functionality to prevent input delay
tnoremap("<space>", "<space>")

-- Copilot
-- nnoremap("<leader>cp", copilot.open({ "right", 0.4 })({ desc = "Copilot Panel", buffer = buffer_number }))

return M
