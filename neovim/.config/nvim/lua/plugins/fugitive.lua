return {
  {
    "tpope/vim-fugitive",
    enabled = not vim.g.vscode,
    lazy = true,
    command = "Git",
    keys = { { "<leader>gg", "<cmd>Git<CR>", mode = "n", desc = "Open Fugitive" } },
  },
  {
    "shumphrey/fugitive-gitlab.vim",
    enabled = not vim.g.vscode,
  },
  { "tpope/vim-rhubarb", enabled = not vim.g.vscode },
}
