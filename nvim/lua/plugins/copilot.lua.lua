return {
  "zbirenbaum/copilot.lua",
  cmd = "Copilot",
  config = function()
    require("copilot").setup({
      suggestion = {enabled = false},
      panel = {enabled = false},
      copilot_node_command = 'node'
    })
  end,
}
