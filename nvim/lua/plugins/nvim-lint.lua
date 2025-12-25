return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			css = { "stylelint" },
			html = { "htmlhint" },
			go = { "golangci-lint" },
		}

		local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint"
		if vim.fn.executable(mason_bin_path) == 1 then
			lint.linters["golangci-lint"] = vim.tbl_deep_extend("force", lint.linters["golangci-lint"] or {}, {
				cmd = mason_bin_path,
				args = { "run" },
				stdin = false,
				stream = "stderr",
				ignore_exitcode = true,
				parser = require("lint.parser").from_pattern(
					"^([^:]+):(%d+):(%d+): (.+) %((.+)%)$",
					{ "file", "lnum", "col", "message", "code" },
					nil,
					{ severity = vim.diagnostic.severity.WARN }
				),
			})
		end

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				pcall(lint.try_lint)
			end,
		})
	end,
}
