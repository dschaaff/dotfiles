return {
  -- Set lualine as statusline
  -- stole some of this from lazyvim
  'nvim-lualine/lualine.nvim',
  -- See `:help lualine.txt`
  event = "VeryLazy",
  init = function()
    vim.g.lualine_laststatus = vim.o.laststatus
    if vim.fn.argc(-1) > 0 then
      -- set an empty statusline till lualine loads
      vim.o.statusline = " "
    else
      -- hide the statusline on the starter page
      vim.o.laststatus = 0
    end
  end,
  opts = {
    options = {
      icons_enabled = false,
      theme = 'auto',
      disabled_filetypes = { statusline = { "dashboard", "alpha", "starter" } },
      component_separators = '|',
      section_separators = '',
    },
    extensions = { "neo-tree", "lazy" },
  },
}
-- vim: ts=2 sts=2 sw=2 et