return {
  -- add helm filetype
  {
    "towolf/vim-helm",
    enabled = not vim.g.vscode,
  },
}
-- vim: ts=2 sts=2 sw=2 et
