return {
	"neovim/nvim-lspconfig",
	ft = { "javascript", "typescript", "typescriptreact", "javascriptreact", "python", "go", "rust", "lua", "vim" },
	config = function()
		require("lspconfig").copilot.setup({
			filetypes = {
				"javascript",
				"typescript",
				"typescriptreact",
				"javascriptreact",
				"python",
				"go",
				"rust",
				"lua",
				"vim",
				"markdown",
				"yaml",
				"json",
				"html",
				"css",
				"sh",
			},
		})
	end,
}
