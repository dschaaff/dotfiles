return {
  'folke/snacks.nvim',
  opts = {
    -- lazygit = {},
  },
  keys = {
    {
      '<leader>gg',
      function()
        Snacks.lazygit()
      end,
      desc = 'LazyGit',
    },
  },
}
