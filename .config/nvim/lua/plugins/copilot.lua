return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				panel = {
					enabled = true,
					auto_refresh = true,
					keymap = {
						jump_prev = "[[",
						jump_next = "]]",
						accept = "<CR>",
						refresh = "gr",
						open = "øø",
					},
					layout = {
						position = "right", -- | top | left | right
						ratio = 0.4,
					},
				},
				suggestion = {
					enabled = true,
					auto_trigger = true,
					hide_during_completion = true,
					debounce = 75,
					keymap = {
						accept = "<F9>",
						accept_word = false,
						accept_line = false,
						next = "<F8>",
						prev = "<F7>",
						dismiss = "<F6>",
					},
				},
				filetypes = {
					yaml = false,
					markdown = false,
					help = false,
					gitcommit = false,
					gitrebase = false,
					hgcommit = false,
					svn = false,
					cvs = false,
					["."] = false,
				},
				copilot_node_command = "node", -- Node.js version must be > 18.x
				server_opts_overrides = {},
			})
		end,
	},
	{
		-- "zbirenbaum/copilot-cmp",
		-- config = function()
		-- 	require("copilot_cmp").setup()
		-- end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		branch = "canary",
		event = "InsertEnter",

		keys = {
			{ "<leader>cp", ":Copilot panel<CR>", desc = "Copilot Panel" },
			{ "<leader>ccp", ":CopilotChat<CR>", desc = "Copilot Panel" },
			{ "<leader>cce", "<cmd>CopilotChatExplain<cr>", desc = "CopilotChat - Explain code" },
			{
				"<leader>ccf",
				"<cmd>CopilotChatFixDiagnostic<cr>", -- Get a fix for the diagnostic message under the cursor.
				desc = "CopilotChat - Fix diagnostic",
			},
			{ "<leader>ccb", "<cmd>CopilotChatBetterNamings<cr>", desc = "CopilotChat - Better Name" },
			{ "<leader>ccr", "<cmd>CopilotChatReview<cr>", desc = "CopilotChat - Review code" },
			{
				"<leader>cce",
				":CopilotChatExplain",
				mode = "x",
				desc = "CopilotChat - Explain",
			},
			{
				"<leader>ccx",
				":CopilotChatInPlace<cr>",
				mode = "x",
				desc = "CopilotChat - Run in-place code",
			},
		},

		config = function()
			require("CopilotChat").setup({
				debug = false, -- Enable debugging

				disable_extra_info = "no", -- Disable extra information (e.g.: system prompt, token count) in the response.
				prompts = {
					-- Code-related prompts
					Explain = "Please explain how the following code works.",
					Review = "Please review the following code and provide suggestions for improvement.",
					Tests = "Please explain how the selected code works, then generate unit tests for it.",
					Refactor = "Please refactor the following code to improve its clarity and readability.",
					FixCode = "Please fix the following code to make it work as intended.",
					BetterNamings = "Please provide better names for the following variables and functions.",
					Documentation = "Please provide documentation for the following code.",
					SwaggerApiDocs = "Please provide documentation for the following API using Swagger.",
					SwaggerJsDocs = "Please write JSDoc for the following API using Swagger.",
					-- Text-related prompts
					Summarize = "Please summarize the following text.",
					Spelling = "Please correct any grammar and spelling errors in the following text.",
					Wording = "Please improve the grammar and wording of the following text.",
					Concise = "Please rewrite the following text to make it more concise.",
				},
			})
		end,

		dependencies = {
			{ "zbirenbaum/copilot.vim" }, -- or github/copilot.vim
			{ "nvim-lua/plenary.nvim" }, -- for curl, log wrapper
		},
		-- See Commands section for default commands if you want to lazy load on them
	},
}
