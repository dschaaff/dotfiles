return {
  'echasnovski/mini.indentscope',
  version = '*',
  enabled = not vim.g.vscode,
  opts = {
    -- symbol = "▏",
    symbol = "│",
    options = { try_as_border = true },
  },
  init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = {
          "help",
          "alpha",
          "dashboard",
          "neo-tree",
          "Trouble",
          "trouble",
          "lazy",
          "mason",
          "notify",
          "toggleterm",
          "lazyterm",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
