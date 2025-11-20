return {
	"folke/noice.nvim",
	event = "VeryLazy",
	opts = {
		lsp = {
			progress = {
				enabled = false,
			},
		},
	},
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
}
