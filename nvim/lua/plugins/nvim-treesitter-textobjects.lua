return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  event = "VeryLazy",
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        lookahead = true,
        selection_modes = {
          ["@parameter.outer"] = "v",
          ["@function.outer"] = "V",
          ["@class.outer"] = "<c-v>",
        },
        include_surrounding_whitespace = true,
      },
    })

    local select_textobject = function(query, query_group)
      return function()
        require("nvim-treesitter-textobjects.select").select_textobject(query, query_group or "textobjects")
      end
    end

    vim.keymap.set({ "x", "o" }, "af", select_textobject("@function.outer"))
    vim.keymap.set({ "x", "o" }, "if", select_textobject("@function.inner"))
    vim.keymap.set({ "x", "o" }, "ac", select_textobject("@class.outer"))
    vim.keymap.set({ "x", "o" }, "ic", select_textobject("@class.inner"), { desc = "Select inner part of a class region" })
    vim.keymap.set({ "x", "o" }, "as", select_textobject("@local.scope", "locals"), { desc = "Select language scope" })
  end,
}
