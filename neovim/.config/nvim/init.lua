vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--single-branch",
		"--branch=main",
		"https://github.com/folke/lazy.nvim.git",
		lazypath,
	})
end
vim.opt.runtimepath:prepend(lazypath)
if vim.g.vscode then
	require("config.vscode")
	require("lazy").setup({
	'tpope/vim-rhubarb',
	'tpope/vim-surround',
	'tpope/vim-rsi',
	})
else

	require("lazy").setup("plugins")

	-- Set colorscheme
	vim.o.termguicolors = true
	vim.cmd [[colorscheme nord]]
end

require("config.options")
