return {
  "yioneko/nvim-yati",
  config = function ()
    require("nvim-treesitter.configs").setup {
    yati = {
      enable = true,
      default_lazy = true,
      default_fallback = "auto"
    },
    indent = {
      enable = false
    }
  }
  end
}
