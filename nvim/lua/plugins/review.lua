return {
	"georgeguimaraes/review.nvim",
	dependencies = {
		"esmuellert/codediff.nvim",
		"MunifTanjim/nui.nvim",
	},
	cmd = { "Review" },
	keys = {
		{ "<leader>r", "<cmd>Review<cr>", desc = "Review: Open diff review" },
	},
	opts = {},
}
