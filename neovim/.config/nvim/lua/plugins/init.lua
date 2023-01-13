return {
	'j-hui/fidget.nvim',
	'navarasu/onedark.nvim',
	'shaunsingh/nord.nvim',
	'folke/neodev.nvim',
	'folke/which-key.nvim',
	'nvim-lua/plenary.nvim',
	'nvim-tree/nvim-web-devicons',
	'MunifTanjim/nui.nvim',
	'tpope/vim-sleuth',
	'tpope/vim-fugitive',
	'tpope/vim-rhubarb',
	'tpope/vim-surround',
	'tpope/vim-rsi',
	'towolf/vim-helm',
	'rhysd/committia.vim' -- better git commit window
},
vim.api.nvim_command('com! FormatJSON %!jq .')
