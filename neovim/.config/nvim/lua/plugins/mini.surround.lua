return {
  {
    "echasnovski/mini.surround",
    -- override mappings to be similar to tpope/vim-surround
    -- https://github.com/echasnovski/mini.surround/blob/main/doc/mini-surround.txt#L53
    opts = {
      mappings = {
        add = "ys", -- Add surrounding in Normal and Visual modes
        delete = "ds", -- Delete surrounding
        find = "gsf", -- Find surrounding (to the right)
        find_left = "gsF", -- Find surrounding (to the left)
        highlight = "gsh", -- Highlight surrounding
        replace = "cs", -- Replace surrounding
        update_n_lines = "gsn", -- Update `n_lines`
      },
    },
  },
}
