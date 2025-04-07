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
    opts.sections.lualine_x[2] = LazyVim.lualine.status(LazyVim.config.icons.kinds.Copilot, function()
      local clients = package.loaded["copilot"] and LazyVim.lsp.get_clients({ name = "copilot", bufnr = 0 }) or {}
      if #clients > 0 then
        local status = require("copilot.status").data.status
        return (status == "InProgress" and "pending") or (status == "Warning" and "error") or "ok"
      end
    end)
  end,
}
-- vim: ts=2 sts=2 sw=2 et
