return {
	"WhoIsSethDaniel/mason-tool-installer.nvim",
	config = function()
		local mason_tool_installer = require("mason-tool-installer")

		local non_lsp_ensure_installed = {
			-- Linters (used by nvim-lint)
			"shellcheck",
			"sqlfluff",
			"markdownlint",
			"stylelint",
			"golangci-lint",

			-- Formatters (used by conform.nvim)
			"eslint_d",
			"prettierd",
			"shfmt",
			"sql-formatter",
			"stylua",
			"goimports",
		}

		mason_tool_installer.setup({
			ensure_installed = non_lsp_ensure_installed,
			auto_update = true,
			run_on_start = true,
		})
	end,
}
