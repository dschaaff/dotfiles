return {
  -- Set lualine as statusline
  -- stole some of this from lazyvim
  "nvim-lualine/lualine.nvim",
  enabled = not vim.g.vscode,
  opts = {
    options = {
      component_separators = "|",
      section_separators = "",
    },
    -- sections = {
    --   lualine_a = { "mode" },
    --   lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = {
      {
        "filename",
        file_status = true,
        newfile_status = false,
        path = 1,
      },
    },
    --   lualine_x = { "encoding", "fileformat", "filetype" },
    --   lualine_y = { "progress" },
    --   lualine_z = { "location" },
    -- },
    -- inactive_sections = {
    --   lualine_a = {},
    --   lualine_b = {},
    --   lualine_c = { "filename" },
    --   lualine_x = { "location" },
    --   lualine_y = {},
    --   lualine_z = {},
    -- },
    extensions = { "fugitive", "neo-tree", "lazy" },
  },
}
-- vim: ts=2 sts=2 sw=2 et
