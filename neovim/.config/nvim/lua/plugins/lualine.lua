local M = {
	'nvim-lualine/lualine.nvim',
}

function M.config()
	require('lualine').setup()
end

return M
