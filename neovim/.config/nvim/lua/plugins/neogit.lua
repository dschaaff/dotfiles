return {
  "NeogitOrg/neogit",
  dependencies = {
    "nvim-lua/plenary.nvim", -- required
    "nvim-telescope/telescope.nvim", -- optional
    "sindrets/diffview.nvim", -- optional
    "ibhagwan/fzf-lua", -- optional
  },
  config = true,
  keys = { { "<leader>gg", "<cmd>Neogit<CR>", mode = "n", desc = "Open Neogit" } },
}
