return {
  "telescope.nvim",
  enabled = not vim.g.vscode,
  keys = {
    { "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "branches" },
  },
  opts = {
    pickers = {
      grep_string = {
        additional_args = { "--hidden" },
      },
      live_grep = {
        additional_args = { "--hidden" },
        glob_pattern = { "!.git" },
      },
    },
  },
}
