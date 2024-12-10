-- Automatically highlighting other uses of the word
-- under the cursor using either LSP, Tree-sitter, or regex matching.
return {
	{
		"RRethy/vim-illuminate",
		lazy = true,
		config = function()
			require("illuminate").configure({
				under_cursor = false,
				filetypes_denylist = {
					"DressingSelect",
					"Outline",
					"TelescopePrompt",
					"alpha",
					"harpoon",
					"toggleterm",
					"neo-tree",
					"Spectre",
					"reason",
				},
			})
		end,
	},
}
