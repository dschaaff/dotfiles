return {
	-- Git related plugins
	{
   'tpope/vim-fugitive',
    enabled = not vim.g.vscode,
  },
	{
   'shumphrey/fugitive-gitlab.vim',
    enabled = not vim.g.vscode,
  },
	{ 'tpope/vim-rhubarb',
    enabled = not vim.g.vscode,
  },
	-- Detect tabstop and shiftwidth automatically
	'tpope/vim-sleuth',
}
-- vim: ts=2 sts=2 sw=2 et
