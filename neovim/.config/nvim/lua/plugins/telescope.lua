return {
  "telescope.nvim",
  enabled = not vim.g.vscode,
  keys = {
    {
      "<leader>ff",
      "<cmd> Telescope find_files hidden=true no_ignore=true find_command=rg,--hidden,--files,--glob,!.git,--glob,!.terraform<CR>",
      desc = "Find Files (root dir)",
    },
    -- { "<leader>fF", "<cmd> Telescope find_files no_ignore=true<CR>", desc = "Find Files (root dir)" },
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
