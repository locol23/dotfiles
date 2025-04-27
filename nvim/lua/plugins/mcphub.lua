return {
  "ravitemer/mcphub.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  cmd = "MCPHub",
  build = "npm install -g mcp-hub@latest",  -- Installs required mcp-hub npm module
  config = function()
    require("mcphub").setup({
      config = vim.fn.expand("~/.config/nvim/mcpservers.json"),  -- Absolute path to config file
    })
  end
}

