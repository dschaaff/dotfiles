vim.api.nvim_set_keymap(
  "n",
  "<leader>e",
  "<Cmd>call VSCodeNotify('workbench.view.explorer')<CR>",
  { noremap = true, silent = true }
)
