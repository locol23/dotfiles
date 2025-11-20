return {
	"mason-org/mason-lspconfig.nvim",
	opts = {},
	dependencies = {
		{ "mason-org/mason.nvim", opts = {} },
		"neovim/nvim-lspconfig",
	},
	config = function()
		local servers = {
			"bashls",
			"lua_ls",
			"yamlls",
			"jsonls",
			"rust_analyzer",
			"ts_ls",
			"eslint",
			"html",
			"cssls",
			"tailwindcss",
			"gopls",
			"graphql",
			"copilot",
		}

		require("mason-lspconfig").setup({
			ensure_installed = servers,
		})

		local capabilities = vim.lsp.protocol.make_client_capabilities()

		-- Configure gopls with enhanced settings
		vim.lsp.config("gopls", {
			cmd = { "gopls" },
			capabilities = capabilities,
			filetypes = { "go", "gomod", "gowork", "gotmpl" },
			root_markers = { "go.work", "go.mod", ".git" },
			settings = {
				gopls = {
					gofumpt = true,
					codelenses = {
						gc_details = false,
						generate = true,
						regenerate_cgo = true,
						run_govulncheck = true,
						test = true,
						tidy = true,
						upgrade_dependency = true,
						vendor = true,
					},
					hints = {
						assignVariableTypes = true,
						compositeLiteralFields = true,
						compositeLiteralTypes = true,
						constantValues = true,
						functionTypeParameters = true,
						parameterNames = true,
						rangeVariableTypes = true,
					},
					analyses = {
						nilness = true,
						unusedparams = true,
						unusedwrite = true,
						useany = true,
					},
					usePlaceholders = true,
					completeUnimported = true,
					staticcheck = true,
					directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
					semanticTokens = true,
				},
			},
		})

		-- Configure eslint with auto-fix on save
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		-- Enable other servers with default config
		for _, server in ipairs(servers) do
			if server ~= "gopls" and server ~= "eslint" then
				vim.lsp.config(server, {
					capabilities = capabilities,
				})
			end
		end

		-- Enable all servers
		vim.lsp.enable(servers)
	end,
}
