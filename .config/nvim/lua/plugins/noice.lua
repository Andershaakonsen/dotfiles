-- Experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.

return {
	"folke/noice.nvim",
	event = "VeryLazy",
	enabled = true,
	opts = {
		-- add any options here
		timeout = 10000,
	},
	dependencies = {
		-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
		"MunifTanjim/nui.nvim",
		-- OPTIONAL:
		--   `nvim-notify` is only needed, if you want to use the notification view.
		--   If not available, we use `mini` as the fallback
		-- "rcarriga/nvim-notify",
	},
}
