return {
  "MagicDuck/grug-far.nvim",
  enabled = not vim.g.vscode,
  cmd = "GrugFar",
  config = function()
    require("grug-far").setup({})
  end,
}
