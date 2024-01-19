return {
	-- tokyonight
	{
		"folke/tokyonight.nvim",
		lazy = false,
		opts = { style = "moon" },
		priority = 10000,
		config = function()
			vim.cmd.colorscheme 'tokyonight'
		end,
	},
}
-- vim: ts=2 sts=2 sw=2 et
