return {

	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			local tokyonight = require("tokyonight")
			tokyonight.setup({
				style = "night", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
				light_style = "day", -- The theme is used when the background is set to light
				transparent = true, -- Enable this to disable setting the background color
				terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)

				styles = {
					-- Style to be applied to different syntax groups
					-- Value is any valid attr-list value for `:help nvim_set_hl`
					comments = { italic = true },
					keywords = { italic = true },
					functions = {},
					variables = {},
					-- Background styles. Can be "dark", "transparent" or "normal"
					sidebars = "transparent", -- style for sidebars, see below
					floats = "transparent", -- style for floating windows
					tabline = "transparent",
				},
				sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
				day_brightness = 0.9, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
				hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
				dim_inactive = false, -- dims inactive windows
				lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold
				--- You can override specific color groups to use other groups or a hex color
				--- function will be called with a ColorScheme table
				---@param colors ColorScheme
				on_colors = function(colors) end,

				--- You can override specific highlights to use other groups or a hex color
				--- function will be called with a Highlights and ColorScheme table
				---@param highlights Highlights
				---@param colors ColorScheme
				on_highlights = function(highlights, colors) end,
			})
			-- tokyonight.load()
		end,
	},
	-- {
	--
	-- 	"navarasu/onedark.nvim",
	-- 	event = "VeryLazy",
	-- 	config = function()
	-- 		local onedark = require("onedark")
	--
	-- 		onedark.setup({
	-- 			-- Main options --
	-- 			style = "deep", -- Default theme style. Choose between 'dark', 'darker', 'cool', 'deep', 'warm', 'warmer' and 'light'
	-- 			transparent = true, -- Show/hide background
	-- 			term_colors = true, -- Change terminal color as per the selected theme style
	-- 			ending_tildes = false, -- Show the end-of-buffer tildes. By default they are hidden
	-- 			cmp_itemkind_reverse = false, -- reverse item kind highlights in cmp menu
	--
	-- 			-- toggle theme style ---
	-- 			toggle_style_key = nil, -- keybind to toggle theme style. Leave it nil to disable it, or set it to a string, for example "<leader>ts"
	-- 			toggle_style_list = { "dark", "darker", "cool", "deep", "warm", "warmer", "light" }, -- List of styles to toggle between
	--
	-- 			-- Change code style ---
	-- 			-- Options are italic, bold, underline, none
	-- 			-- You can configure multiple style with comma separated, For e.g., keywords = 'italic,bold'
	-- 			code_style = {
	-- 				comments = "italic",
	-- 				keywords = "none",
	-- 				functions = "none",
	-- 				strings = "none",
	-- 				variables = "none",
	-- 			},
	-- 			-- Lualine options --
	-- 			lualine = {
	-- 				transparent = true, -- lualine center bar transparency
	-- 			},
	--
	-- 			-- Custom Highlights --
	-- 			colors = {}, -- Override default colors
	-- 			highlights = {}, -- Override highlight groups
	-- 		})
	-- 		-- onedark.load()
	-- 	end,
	-- },
	{ "diegoulloao/neofusion.nvim", priority = 1000, config = true, opts = ... },
	-- {
	--   "catppuccin/nvim",
	--   lazy = true,
	--   name = "catppuccin",
	--   opts = {
	--     transparent_background = true,
	--     no_italic = true,
	--     no_bold = false,
	--     integrations = {
	--       harpoon = true,
	--       fidget = true,
	--       cmp = true,
	--       flash = true,
	--       gitsigns = true,
	--       illuminate = true,
	--       indent_blankline = { enabled = true },
	--       lsp_trouble = true,
	--       mason = true,
	--       mini = true,
	--       native_lsp = {
	--         enabled = true,
	--         underlines = {
	--           errors = { "undercurl" },
	--           hints = { "undercurl" },
	--           warnings = { "undercurl" },
	--           information = { "undercurl" },
	--         },
	--       },
	--       navic = { enabled = true, custom_bg = "lualine" },
	--       neotest = true,
	--       noice = true,
	--       notify = true,
	--       neotree = true,
	--       semantic_tokens = true,
	--       telescope = true,
	--       treesitter = true,
	--       which_key = true,
	--     },
	--     highlight_overrides = {
	--       all = function(colors)
	--         return {
	--           DiagnosticVirtualTextError = { bg = colors.none },
	--           DiagnosticVirtualTextWarn = { bg = colors.none },
	--           DiagnosticVirtualTextHint = { bg = colors.none },
	--           DiagnosticVirtualTextInfo = { bg = colors.none },
	--         }
	--       end,
	--     },
	--     color_overrides = {
	--       mocha = {
	--         -- I don't think these colours are pastel enough by default!
	--         peach = "#fcc6a7",
	--         green = "#d2fac5",
	--       },
	--     },
	--   },
	-- },
	-- {
	-- 	"scottmckendry/cyberdream.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	config = function()
	-- 		require("cyberdream").setup({
	-- 			-- Recommended - see "Configuring" below for more config options
	-- 			transparent = true,
	-- 			italic_comments = true,
	-- 			hide_fillchars = true,
	-- 			borderless_telescope = true,
	-- 			terminal_colors = true,
	-- 		})
	-- 		-- vim.cmd("colorscheme cyberdream") -- set the colorscheme
	-- 	end,
	-- },
}
