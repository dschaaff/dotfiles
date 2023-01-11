vim.g.maplocalleader = " "
vim.g.maplocalleader = " "

require("config.lazy")

-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]

require ("config.options")

