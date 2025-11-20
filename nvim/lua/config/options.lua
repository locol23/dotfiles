-- encoding
vim.o.encoding = "utf-8"
vim.scriptencoding = "utf-8"

vim.wo.number = true
vim.opt.clipboard:append{'unnamedplus'}

-- indent
vim.o.expandtab = true vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- file auto-reload
vim.o.autoread = true

-- colorscheme
vim.cmd.colorscheme("hybrid")

-- diagnostics
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})


