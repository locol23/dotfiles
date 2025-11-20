return {
  "neovim/nvim-lspconfig",
  ft = "graphql",
  config = function()
    -- Completely disable LSP formatting for GraphQL files
    local augroup = vim.api.nvim_create_augroup("DisableGraphQLFormatting", { clear = true })

    -- Disable on BufEnter for GraphQL files
    vim.api.nvim_create_autocmd("BufEnter", {
      group = augroup,
      pattern = { "*.graphql", "*.gql" },
      callback = function(args)
        local bufnr = args.buf
        -- Find all attached language servers
        for _, client in ipairs(vim.lsp.get_active_clients({ bufnr = bufnr })) do
          -- Forcefully disable formatting capabilities
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end

        -- Set buffer-local variable to indicate formatting is disabled
        vim.b[bufnr].format_disabled = true

      end,
    })

    -- Override the vim.lsp.buf.format function for GraphQL files
    local orig_format = vim.lsp.buf.format
    vim.lsp.buf.format = function(opts)
      opts = opts or {}
      local bufnr = opts.bufnr or vim.api.nvim_get_current_buf()
      local filetype = vim.bo[bufnr].filetype

      if filetype == "graphql" then
        return
      end

      return orig_format(opts)
    end


    -- Disable conform.nvim formatting for GraphQL if conform is present
    if pcall(require, "conform") then
      local conform = require("conform")
      conform.setup({
        formatters_by_ft = {
          graphql = {}, -- Empty formatters list for GraphQL
        }
      })
    end

    -- Create a very high priority BufWritePre hook to prevent any formatting
    vim.api.nvim_create_autocmd("BufWritePre", {
      group = augroup,
      pattern = { "*.graphql", "*.gql" },
      callback = function(args)
        -- Check if there's any autoformat happening on save and block it
        if vim.b[args.buf].autoformat or vim.g.autoformat then
          vim.b[args.buf].autoformat = false
          vim.b[args.buf]._autoformat_temp_disabled = true
          return true
        end
      end,
      desc = "Disable autoformatting for GraphQL files",
      priority = 9999, -- Very high priority to run before other autocommands
    })

    -- Restore autoformat setting after save
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = augroup,
      pattern = { "*.graphql", "*.gql" },
      callback = function(args)
        if vim.b[args.buf]._autoformat_temp_disabled then
          vim.b[args.buf].autoformat = true
          vim.b[args.buf]._autoformat_temp_disabled = nil
        end
      end,
      desc = "Restore autoformatting setting after save",
    })
  end,
}