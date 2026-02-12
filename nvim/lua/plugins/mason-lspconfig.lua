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

		-- ESLint: configure with EslintFixAll command and fix on save
		vim.lsp.config("eslint", {
			capabilities = capabilities,
			on_attach = function(client, bufnr)
				vim.api.nvim_buf_create_user_command(bufnr, "EslintFixAll", function()
					client:request_sync("workspace/executeCommand", {
						command = "eslint.applyAllFixes",
						arguments = {
							{
								uri = vim.uri_from_bufnr(bufnr),
								version = vim.lsp.util.buf_versions[bufnr],
							},
						},
					}, nil, bufnr)
				end, { desc = "Fix all eslint problems for this buffer" })

				vim.api.nvim_create_autocmd("BufWritePre", {
					buffer = bufnr,
					command = "EslintFixAll",
				})
			end,
		})

		-- Enable other servers with default config
		for _, server in ipairs(servers) do
			if server ~= "gopls" and server ~= "eslint" and server ~= "copilot" then
				vim.lsp.config(server, {
					capabilities = capabilities,
				})
			end
		end

		-- Enable all configured servers (excluding copilot which is handled by copilot.lua plugin)
		local servers_to_enable = {}
		for _, server in ipairs(servers) do
			if server ~= "copilot" then
				table.insert(servers_to_enable, server)
			end
		end
		vim.lsp.enable(servers_to_enable)
	end,
}
