return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    {
      "williamboman/mason-lspconfig.nvim",
      cmd = { "LspInstall", "LspUninstall" },
      config = function()
        local mason_lspconfig = require("mason-lspconfig")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local navic = require("nvim-navic")
        local on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            navic.attach(client, bufnr)
          end
        end
        local lsp_servers = {
          "pyright",
          "ruff",
          "bashls",
          "lua_ls",
          "yamlls",
          "jsonls",
          "taplo",
          "rust_analyzer",
          "ts_ls",
          "html",
          "cssls",
          "eslint",
          "tailwindcss",
        }
        mason_lspconfig.setup({
          ensure_installed = lsp_servers,
          automatic_installation = true,
        })
        mason_lspconfig.setup_handlers({
          function(server)
            local opt = {
              capabilities = capabilities,
              on_attach = on_attach,
            }
            require("lspconfig")[server].setup(opt)
          end,
        })
      end,
    },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function()
        local set = vim.keymap.set
        set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", { buffer = true })
        set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { buffer = true })
        set("n", "gh", "<cmd>lua vim.lsp.buf.hover()<CR>", { buffer = true })
        set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", { buffer = true })
        set("n", "ge", "<cmd>lua vim.diagnostic.open_float()<CR>")
        -- set("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", { buffer = true })
        set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", { buffer = true })
        set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", { buffer = true })
        set("n", "<space>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", { buffer = true })
        set("n", "<space>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", { buffer = true })
        set("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", { buffer = true })
        set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", { buffer = true })
        set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", { buffer = true })
        set("n", "<space>e", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", { buffer = true })
        set("n", "[d", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", { buffer = true })
        set("n", "]d", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", { buffer = true })
        set("n", "<space>q", "<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>", { buffer = true })
        set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", { buffer = true })
      end,
    })

    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          return string.format("%s (%s: %s)", diagnostic.message, diagnostic.source, diagnostic.code)
        end,
      },
      signs = true,
      underline = true,
    })
  end,
}
