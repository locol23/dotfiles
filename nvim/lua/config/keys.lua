-- keymap
vim.api.nvim_set_var('mapleader', ' ')
vim.api.nvim_set_var('maplocalleader', ';')
vim.keymap.set('n', '<leader>h', ':%s///<left><left>')
vim.keymap.set('n', '<C-h>', '<C-W>h')
vim.keymap.set('n', '<C-j>', '<C-W>j')
vim.keymap.set('n', '<C-k>', '<C-W>k')
vim.keymap.set('n', '<C-l>', '<C-W>l')

