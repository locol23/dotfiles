return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1

    vim.opt.termguicolors = true

    vim.keymap.set('n', 'sf', ':NvimTreeToggle<cr>', { noremap = true, silent = true, desc = 'Toggle NvimTree' })

    local function on_attach(bufnr)
      local api = require "nvim-tree.api"

      local function opts(desc)
        return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
      end

      -- default mappings
      api.config.mappings.default_on_attach(bufnr)

      -- custom mappings
      vim.keymap.set('n', '<C-t>', api.tree.change_root_to_parent,        opts('Up'))
      vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
      vim.keymap.set('n', 'l',     api.node.open.edit,                    opts('Open'))
      vim.keymap.set('n', 'h',     api.node.navigate.parent_close,        opts('Close Directory'))
      vim.keymap.set('n', 'sf',    api.tree.close,                        opts('Close'))
      vim.keymap.set('n', 'fd',    api.fs.remove,                         opts('Delete'))
      vim.keymap.set('n', 'yy',    api.fs.copy.node,                      opts('Copy'))
      vim.keymap.set('n', 'p',     api.fs.paste,                          opts('Paste'))
      vim.keymap.set('n', 'r',     api.fs.rename,                         opts('Rename'))
    end

    require("nvim-tree").setup({
      sort = {
        sorter = "case_sensitive",
      },
      view = {
        width = 30,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
        git_ignored = false
      },
      filesystem_watchers = {
        enable = true,
        debounce_delay = 50,
      },
      update_focused_file = {
        enable = true,
      },
      on_attach = on_attach,
      actions = {
        open_file = {
          quit_on_open = true,
        },
      },
    })
  end,
}
