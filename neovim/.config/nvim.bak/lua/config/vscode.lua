# https://github.com/vscode-neovim/vscode-neovim/wiki/Plugins#vim-commentary
vim.api.nvim_set_keymap('x', 'gc', '<Plug>VSCodeCommentary', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gc', '<Plug>VSCodeCommentary', { noremap = true, silent = true })
vim.api.nvim_set_keymap('o', 'gc', '<Plug>VSCodeCommentary', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', 'gc', '<Plug>VSCodeCommentaryLine', { noremap = true, silent = true })
