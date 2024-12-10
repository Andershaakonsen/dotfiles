return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		ensure_installed = { "bash", "c", "diff", "html", "lua", "luadoc", "markdown", "vim", "vimdoc", "c_sharp" },
		-- Autoinstall languages that are not installed
		auto_install = true,
		highlight = {
			enable = true,
			-- Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
			--  If you are experiencing weird indenting issues, add the language to
			--  the list of additional_vim_regex_highlighting and disabled languages for indent.
			additional_vim_regex_highlighting = { "ruby" },
		},
		indent = { enable = true, disable = { "ruby" } },
	},
	dependencies = {
		-- Additional text objects for treesitter
		"nvim-treesitter/nvim-treesitter-textobjects",
	},
	config = function(_, opts)
		-- [[ Configure Treesitter ]] See `:help nvim-treesitter`

		-- Prefer git instead of curl in order to improve connectivity in some environments
		require("nvim-treesitter.install").prefer_git = true
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			highlight = {
				enable = true,
			},

			indent = { enable = true },

			ensure_installed = {
				"json",
				"javascript",
				"bash",
				"typescript",
				"tsx",
				"yaml",
				"html",
				"css",
				"c_sharp",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"dockerfile",
				"gitignore",
				"query",
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})

		-- There are additional nvim-treesitter modules that you can use to interact
		-- with nvim-treesitter. You should go explore a few and see what interests you:
		--
		--    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
		--    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
		--    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
	end,

	-- {
	--
	--   "nvim-treesitter/nvim-treesitter",
	--   build = function()
	--     require("nvim-treesitter.install").update({ with_sync = true })
	--   end,
	--   event = { "BufEnter" },
	--   dependencies = {
	--     -- Additional text objects for treesitter
	--     "nvim-treesitter/nvim-treesitter-textobjects",
	--   },
	--   config = function()
	--     ---@diagnostic disable: missing-fields
	--     require("nvim-treesitter.configs").setup({
	--       ensure_installed = {
	--         "bash",
	--         "c",
	--         "c_sharp",
	--         "css",
	--         "gleam",
	--         "graphql",
	--         "html",
	--         "javascript",
	--         "json",
	--         "lua",
	--         "markdown",
	--         "ocaml",
	--         "ocaml_interface",
	--         "prisma",
	--         "tsx",
	--         "typescript",
	--         "vim",
	--         -- "yaml", This is currently borked see: https://github.com/ikatyang/tree-sitter-yaml/issues/53
	--       },
	--       sync_install = false,
	--       highlight = {
	--         enable = true,
	--         additional_vim_regex_highlighting = false,
	--       },
	--       indent = {
	--         enable = true,
	--         disable = { "ocaml", "ocaml_interface" },
	--       },
	--       autopairs = {
	--         enable = true,
	--       },
	--       autotag = {
	--         enable = true,
	--       },
	--       --[[ context_commentstring = {
	-- 			enable = true,
	-- 			enable_autocmd = false,
	-- 		}, ]]
	--       incremental_selection = {
	--         enable = true,
	--         keymaps = {
	--           init_selection = "<c-space>",
	--           node_incremental = "<c-space>",
	--           scope_incremental = "<c-s>",
	--           node_decremental = "<c-backspace>",
	--         },
	--       },
	--       textobjects = {
	--         select = {
	--           enable = true,
	--           lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
	--           keymaps = {
	--             -- You can use the capture groups defined in textobjects.scm
	--             ["aa"] = "@parameter.outer",
	--             ["ia"] = "@parameter.inner",
	--             ["af"] = "@function.outer",
	--             ["if"] = "@function.inner",
	--             ["ac"] = "@class.outer",
	--             ["ic"] = "@class.inner",
	--           },
	--         },
	--         move = {
	--           enable = true,
	--           set_jumps = true, -- whether to set jumps in the jumplist
	--           goto_next_start = {
	--             ["]m"] = "@function.outer",
	--             ["]]"] = "@class.outer",
	--           },
	--           goto_next_end = {
	--             ["]M"] = "@function.outer",
	--             ["]["] = "@class.outer",
	--           },
	--           goto_previous_start = {
	--             ["[m"] = "@function.outer",
	--             ["[["] = "@class.outer",
	--           },
	--           goto_previous_end = {
	--             ["[M"] = "@function.outer",
	--             ["[]"] = "@class.outer",
	--           },
	--         },
	--       },
	--     })
	--   end,
	-- },
}
