-- Configurable tools for working with markdown files in Neovim.
return {
	{
		ft = "markdown", -- or 'event = "VeryLazy"'
		"tadmccorkle/markdown.nvim",
		opts = {
			-- configuration here or empty for defaults
		},
	},
	{
		-- Install markdown preview, use npx if available.
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		enabled = true,
		build = function(plugin)
			if vim.fn.executable("npx") then
				vim.cmd("!cd " .. plugin.dir .. " && cd app && npx --yes yarn install")
			else
				vim.cmd([[Lazy load markdown-preview.nvim]])
				vim.fn["mkdp#util#install"]()
			end
		end,
		keys = {
			{
				"<leader>mp",
				ft = "markdown",
				"<cmd>MarkdownPreviewToggle<cr>",
				desc = "Markdown Preview",
			},
		},
		init = function()
			if vim.fn.executable("npx") then
				vim.g.mkdp_filetypes = { "markdown" }
			end
		end,
	},
}
