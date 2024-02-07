return {
	"folke/trouble.nvim",
	cmd = { "TroubleToggle", "Trouble" },
	event = "VeryLazy",
	opts = { use_diagnostic_signs = true },
	keys = {
		{ "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics" },
		{ "<leader>xw", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
		{ "n", "n", desc = "Next highlight search" },
	},
}
