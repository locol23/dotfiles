return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install({
      "c", "lua", "vim", "vimdoc", "query", "python", "go", "gomod",
    })

    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match) or args.match
        if pcall(vim.treesitter.language.inspect, lang) then
          vim.treesitter.start()
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    vim.treesitter.language.register("markdown", "octo")
  end,
}
