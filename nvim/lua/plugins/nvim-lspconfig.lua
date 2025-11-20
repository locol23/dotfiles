return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			callback = function()
				local set = vim.keymap.set
				set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
				set("n", "gd", "<cmd>lua require('telescope.builtin').lsp_definitions()<CR>", { buffer = true })
				set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
				set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
				-- set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
				set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
				set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
				set(
					"n",
					"<space>wl",
					"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
					{ buffer = true }
				)
				set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
				set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
				set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
				set("n", "gr", "<cmd>lua require('telescope.builtin').lsp_references()<CR>", { buffer = true })
				set("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", { buffer = true })
				set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", { buffer = true })
				set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", { buffer = true })
				set("n", "<space>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", { buffer = true })
			end,
		})

		vim.diagnostic.config({
			virtual_text = {
				spacing = 4,
				source = "if_many",
				prefix = "●",
				format = function(diagnostic)
					if diagnostic.source and diagnostic.code then
						return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
					else
						return diagnostic.message
					end
				end,
			},
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = "✘",
					[vim.diagnostic.severity.WARN] = "▲",
					[vim.diagnostic.severity.HINT] = "⚑",
					[vim.diagnostic.severity.INFO] = "»",
				},
			},
			underline = true,
			update_in_insert = false,
			severity_sort = true,
		})
	end,
}
