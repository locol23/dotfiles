-- encoding
vim.o.encoding = "utf-8"
vim.scriptencoding = "utf-8"

vim.wo.number = true
vim.opt.clipboard:append{'unnamedplus'}

-- indent
vim.o.expandtab = true vim.o.tabstop = 2
vim.o.shiftwidth = 2

-- colorscheme
vim.cmd.colorscheme("hybrid")

