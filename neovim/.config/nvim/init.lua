vim.g.maplocalleader = " "
vim.g.maplocalleader = " "

if vim.g.vscode then
	require("config.vscode")
else
	require("config.lazy")

	-- Set colorscheme
	vim.o.termguicolors = true
	vim.cmd [[colorscheme nord]]
end

require ("config.options")

