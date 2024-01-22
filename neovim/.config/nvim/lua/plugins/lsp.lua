return {
	{
		-- LSP Configuration & Plugins
		'neovim/nvim-lspconfig',
		enabled = not vim.g.vscode,
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			{
				'williamboman/mason.nvim',
				config = true,
				cmd = "Mason",
				keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
				opts = {
					ensure_installed = {
						"markdownlint",
						"shellcheck"
					}
				}
			},
			'williamboman/mason-lspconfig.nvim',
			'folke/which-key.nvim',
			{
				"b0o/SchemaStore.nvim",
				lazy = true,
				version = false,
			},

			-- Useful status updates for LSP
			-- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
			{ 'j-hui/fidget.nvim', opts = {} },

			'folke/neodev.nvim',
		},
	},
	{
		-- Autocompletion
		'hrsh7th/nvim-cmp',
		dependencies = {
			-- Snippet Engine & its associated nvim-cmp source
			'L3MON4D3/LuaSnip',
			'saadparwaiz1/cmp_luasnip',
			'hrsh7th/cmp-buffer',

			-- Adds LSP completion capabilities
			'hrsh7th/cmp-nvim-lsp',
			'hrsh7th/cmp-path',
			'saadparwaiz1/cmp_luasnip',

			-- Adds a number of user-friendly snippets
			'rafamadriz/friendly-snippets',
			{
				'zbirenbaum/copilot-cmp',
				dependencies = { 'copilot.lua' }
			}
		},
	},
}
