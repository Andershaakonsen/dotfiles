return {
	"nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
		-- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
	},
	event = "VeryLazy",
	config = function()
		require("neo-tree").setup({
			popup_border_style = "rounded",
			close_if_last_window = true,
			enable_diagnostics = true,
			enable_git_status = true,
			-- window = {
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "NeoTreeFileName",
			},
			name = {
				trailing_slash = false,
				use_git_status_colors = true,
				highlight = "",
			},
			filesystem = {
				filtered_items = {
					visible = false, -- when true, they will just be displayed differently than normal items
					hide_dotfiles = false,
					hide_gitignored = true,
					hide_by_name = {
						--"node_modules"
					},
				},
			},
		})
	end,
	keys = {
		{
			"<leader>e",
			-- function()
			--     if vim.bo.filetype == "neo-tree" then
			--         vim.cmd("Neotree close")
			--     else
			--         -- vim.cmd("Neotree float")
			--         vim.cmd("Neotree toggle")
			--     end
			-- end,
			"<cmd>Neotree toggle reveal_force_cwd<cr>",
			desc = "Explorer",
		},
	},
}
