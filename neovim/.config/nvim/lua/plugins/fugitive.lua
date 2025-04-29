return {
  {
    "tpope/vim-fugitive",
    enabled = not vim.g.vscode,
    lazy = false,
    cmd = "Git",
    -- keys = { { "<leader>gg", "<cmd>Git<CR>", mode = "n", desc = "Open Fugitive" } },
  },
  {
    "shumphrey/fugitive-gitlab.vim",
    lazy = false,
    dependencies = { "tpope/vim-fugitive" },
    enabled = not vim.g.vscode,
  },
  {
    "tpope/vim-rhubarb",
    enabled = not vim.g.vscode,
  },
}
