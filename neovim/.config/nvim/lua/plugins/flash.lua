return {
  "folke/flash.nvim",
  -- disable flash, it conflicts with the vim surround keymaps I like
  enabled = false,
  opts = {
    modes = {
      search = {
        enabled = false,
      },
    },
  },
}
