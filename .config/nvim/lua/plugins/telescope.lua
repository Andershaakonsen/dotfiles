-- Highly extendable fuzzy finder over lists.
return {
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				-- build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
				-- cond = vim.fn.executable("cmake") == 1,
			},
		},

		config = function()
			local actions = require("telescope.actions")
			local trouble = require("trouble.providers.telescope")

			local open_with_trouble = require("trouble.sources.telescope").open

			local troubleSources = require("trouble.sources.telescope")
			-- local telescope = require("telescope")
			-- telescope.setup({
			-- 	defaults = {
			-- 		mappings = {
			-- 			i = { ["<c-t>"] = trouble.open_with_trouble },
			-- 			n = { ["<c-t>"] = trouble.open_with_trouble },
			-- 		},
			-- 	},
			-- })
			require("telescope").setup({

				defaults = {
					mappings = {
						i = {
							["<C-k>"] = actions.move_selection_previous,
							["<C-j>"] = actions.move_selection_next,
							["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
							["<C-x>"] = actions.delete_buffer,

							["<leader>tx"] = open_with_trouble,
						},
						n = {
							["<leader>tx"] = open_with_trouble,
						},
					},
					file_ignore_patterns = {
						"node_modules",
						"yarn.lock",
						".git",
						".sl",
						"_build",
						".next",
					},
					hidden = true,
					layout_strategy = "vertical",
					layout_config = {
						width = 0.6,
						-- other layout configuration here
					},
					shorten_path = true,
					path_display = { "truncate" },

					pickers = {
						find_files = {
							results_title = true,
						},
						git_files = {
							results_title = false,
						},
						git_status = {
							expand_dir = false,
						},
						git_commits = {
							mappings = {
								i = {
									["<C-M-d>"] = function()
										-- Open in diffview
										local selected_entry = action_state.get_selected_entry()
										print("Selected: ", selected_entry)
										local value = selected_entry.value
										-- close Telescope window properly prior to switching windows
										vim.api.nvim_win_close(0, true)
										vim.cmd("stopinsert")
										vim.schedule(function()
											vim.cmd(("DiffviewOpen %s^!"):format(value))
										end)
									end,
								},
							},
						},
					},
				},
			})

			-- Enable telescope fzf native, if installed
			pcall(require("telescope").load_extension, "fzf")
		end,
	},
}
