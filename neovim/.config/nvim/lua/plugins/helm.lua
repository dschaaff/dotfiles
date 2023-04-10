return {
  -- add helm filetype
  {
    "towolf/vim-helm",
    enabled = not vim.g.vscode,
  },
}
