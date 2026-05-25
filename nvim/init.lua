if vim.iter then
	vim.tbl_flatten = function(t) return vim.iter(t):flatten(math.huge):totable() end
end

require("config.keys")
require("config.lazy")
require("config.options")
require("config.autocmd")
