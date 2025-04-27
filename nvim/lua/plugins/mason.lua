return {
  "williamboman/mason.nvim",
  cmd = {
    "Mason",
    "MasonInstall",
    "MasonUninstall",
    "MasonUninstallAll",
    "MasonLog",
    "MasonUpdate",
    "MasonUpdateAll",
  },
  dependencies = {
    "williamboman/mason-lspconfig.nvim",
    "nvimtools/none-ls.nvim",
    "jay-babu/mason-null-ls.nvim",
  },
  config = function()
    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_uninstalled = "✗",
          package_pending = "⟳",
        },
      },
    })

    -- mason-null-ls の設定
    require("mason-null-ls").setup({
      ensure_installed = {
        "stylua", -- Luaフォーマッター
      },
      automatic_installation = true,
      handlers = {},
    })
  end,
  build = ":MasonUpdate",
}
