return {
  'aaronik/treewalker.nvim',
  opts = {
    highlight = true,
    highlight_duration = 250,
    highlight_group = 'CursorLine',
  },
  config = function()
    vim.keymap.set({ 'n', 'v' }, '<S-k>', '<cmd>Treewalker Up<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<S-j>', '<cmd>Treewalker Down<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<S-h>', '<cmd>Treewalker Left<cr>', { silent = true })
    vim.keymap.set({ 'n', 'v' }, '<S-l>', '<cmd>Treewalker Right<cr>', { silent = true })
  end,
}
