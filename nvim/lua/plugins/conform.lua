return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters_by_ft = {
				javascript = { "prettierd" },
				javascriptreact = { "prettierd" },
				typescript = { "prettierd" },
				typescriptreact = { "prettierd" },
				vue = { "prettierd" },
				svelte = { "prettierd" },
				css = { "prettierd" },
				scss = { "prettierd" },
				less = { "prettierd" },
				html = { "prettierd" },
				json = { "prettierd" },
				jsonc = { "prettierd" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				["markdown.mdx"] = { "prettierd" },
				lua = { "stylua" },
				go = { "goimports" },
				rust = { "rustfmt" },
				sql = { "sql-formatter" },
				sh = { "shfmt" },
			},
			formatters = {},
			format_on_save = {
				lsp_format = "fallback",
				async = false,
				timeout_ms = 10000,
			},
		})
	end,
}
