return {
  {
    'tpope/vim-fugitive',
    enabled = not vim.g.vscode,
    lazy = false,
    cmd = 'Git',
    keys = { { '<leader>gb', '<cmd>Git blame<CR>', mode = 'n', desc = 'Open Fugitive' } },
  },
  {
    'farhanmustar/fugitive-delta.nvim',
    dependencies = { 'tpope/vim-fugitive' },
    enabled = not vim.g.vscode,
  },
  {
    'shumphrey/fugitive-gitlab.vim',
    lazy = false,
    dependencies = { 'tpope/vim-fugitive' },
    enabled = not vim.g.vscode,
  },
  {
    'tpope/vim-rhubarb',
    enabled = not vim.g.vscode,
  },
}
