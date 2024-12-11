local nnoremap = require("user.keymap_utils").nnoremap

vim.api.nvim_create_autocmd("FileType", {
	desc = "Settings added to markdown files",
	pattern = "markdown",
	callback = function()
		-- Text longer than the width of the window will wrap and display on the next line
		vim.wo.wrap = true
		-- J and K move down and up by visual lines
		nnoremap("j", "gj")
		nnoremap("k", "gk")
	end,
})
