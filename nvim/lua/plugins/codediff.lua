return {
	"esmuellert/codediff.nvim",
	dependencies = { "MunifTanjim/nui.nvim" },
	cmd = "CodeDiff",
	keys = {
		{ "<leader>dv", "<cmd>CodeDiff<cr>", desc = "CodeDiff: Git status" },
		{ "<leader>df", "<cmd>CodeDiff file HEAD<cr>", desc = "CodeDiff: Diff file vs HEAD" },
		{ "<leader>dh", "<cmd>CodeDiff history<cr>", desc = "CodeDiff: Commit history" },
	},
}
