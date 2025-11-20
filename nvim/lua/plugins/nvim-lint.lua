return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			javascriptreact = { "eslint_d" },
			typescriptreact = { "eslint_d" },
			jsx = { "eslint_d" },
			tsx = { "eslint_d" },
			svelte = { "eslint_d" },
			json = { "eslint_d" },
			markdown = { "markdownlint" },
			sh = { "shellcheck" },
			sql = { "sqlfluff" },
			yaml = { "eslint_d" },
			css = { "stylelint" },
			html = { "htmlhint" },
			go = { "golangci-lint" },
		}

		-- Function to find ESLint config file
		local function find_eslint_config(file_path)
			local config_names = {
				"eslint.config.js",
				"eslint.config.mjs",
				"eslint.config.cjs",
				".eslintrc.js",
				".eslintrc.mjs",
				".eslintrc.cjs",
				".eslintrc.json",
				".eslintrc.yaml",
				".eslintrc.yml",
			}

			local cwd = vim.fn.getcwd()
			
			-- First, search downward from cwd
			local function search_directory(dir)
				local configs_found = {}
				local handle = io.popen("find '" .. dir .. "' -maxdepth 10 -type f 2>/dev/null")
				if handle then
					for line in handle:lines() do
						local filename = vim.fn.fnamemodify(line, ":t")
						for _, config_name in ipairs(config_names) do
							if filename == config_name then
								local config_dir = vim.fn.fnamemodify(line, ":h")
								table.insert(configs_found, { path = config_dir, config_file = line })
							end
						end
					end
					handle:close()
				end
				return configs_found
			end

			-- Search downward from cwd
			local configs = search_directory(cwd)
			
			if #configs > 0 then
				-- Find the config closest to the file path
				local best_config = nil
				local best_distance = math.huge
				
				for _, config in ipairs(configs) do
					-- Check if the file is within this config's directory tree
					if vim.startswith(file_path, config.path) then
						local distance = #file_path - #config.path
						if distance < best_distance then
							best_distance = distance
							best_config = config.path
						end
					end
				end
				
				if best_config then
					return best_config
				end
			end

			-- If not found, search upward from cwd
			local current_dir = cwd
			while current_dir ~= "/" and current_dir ~= vim.fn.expand("~") do
				for _, config_name in ipairs(config_names) do
					local config_path = current_dir .. "/" .. config_name
					if vim.fn.filereadable(config_path) == 1 then
						return current_dir
					end
				end
				current_dir = vim.fn.fnamemodify(current_dir, ":h")
			end

			return nil
		end

		-- Set the Mason path for golangci-lint before creating autocommands
		local mason_bin_path = vim.fn.stdpath("data") .. "/mason/bin/golangci-lint"
		if vim.fn.executable(mason_bin_path) == 1 then
			-- Create a custom linter configuration for golangci-lint
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

		-- Create a custom eslint_d linter with dynamic cwd
		local eslint_d_mason_path = vim.fn.stdpath("data") .. "/mason/bin/eslint_d"
		if vim.fn.executable(eslint_d_mason_path) == 1 then
			lint.linters["eslint_d"] = vim.tbl_deep_extend("force", lint.linters["eslint_d"] or {}, {
				cmd = eslint_d_mason_path,
				args = function()
					return {
						"--no-warn-ignored",
						"--format",
						"json",
						"--stdin",
						"--stdin-filename",
						vim.api.nvim_buf_get_name(0),
					}
				end,
				stdin = true,
				stream = "stdout",
				ignore_exitcode = true,
				cwd = function()
					local file_path = vim.api.nvim_buf_get_name(0)
					local config_dir = find_eslint_config(file_path)
					return config_dir or vim.fn.getcwd()
				end,
				parser = function(output, bufnr)
					if output == "" then
						return {}
					end

					local ok, decoded = pcall(vim.json.decode, output)
					if not ok or not decoded or not decoded[1] then
						return {}
					end

					local diagnostics = {}
					for _, result in ipairs(decoded) do
						if result.messages then
							for _, msg in ipairs(result.messages) do
								table.insert(diagnostics, {
									lnum = msg.line > 0 and msg.line - 1 or 0,
									col = msg.column > 0 and msg.column - 1 or 0,
									end_lnum = msg.endLine and msg.endLine > 0 and msg.endLine - 1 or nil,
									end_col = msg.endColumn and msg.endColumn > 0 and msg.endColumn - 1 or nil,
									severity = msg.severity == 1 and vim.diagnostic.severity.WARN or vim.diagnostic.severity.ERROR,
									message = msg.message,
									source = "eslint",
									code = msg.ruleId,
								})
							end
						end
					end
					return diagnostics
				end,
			})
		end

		-- Create autocommand for linting
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = vim.api.nvim_create_augroup("lint", { clear = true }),
			callback = function()
				pcall(lint.try_lint)
			end,
		})
	end,
}
