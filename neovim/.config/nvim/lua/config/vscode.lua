-- vim.g.mapleader = " "
-- vim.g.maplocalleader = " "
vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)
vim.api.nvim_set_keymap("x", "gc", "<Plug>VSCodeCommentary", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gc", "<Plug>VSCodeCommentary", { noremap = true, silent = true })
vim.api.nvim_set_keymap("o", "gc", "<Plug>VSCodeCommentary", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "gc", "<Plug>VSCodeCommentaryLine", { noremap = true, silent = true })
-- vim: ts=2 sts=2 sw=2 et
