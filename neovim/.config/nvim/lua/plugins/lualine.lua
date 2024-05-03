return {
  -- Set lualine as statusline
  -- stole some of this from lazyvim
  "nvim-lualine/lualine.nvim",
  enabled = not vim.g.vscode,
  opts = function(_, opts)
    opts.options = {
      component_separators = "|",
      section_separators = "",
    }
    opts.extensions = { "fugitive", "neo-tree", "lazy" }
    table.remove(opts.sections.lualine_c)
    table.insert(opts.sections.lualine_c, {
      "filename",
      file_status = true,
      path = 3,
    })
  end,
}
-- vim: ts=2 sts=2 sw=2 et
