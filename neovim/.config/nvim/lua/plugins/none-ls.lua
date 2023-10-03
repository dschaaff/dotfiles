return {
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "vale")
      table.insert(opts.ensure_installed, "markdownlint")
      table.insert(opts.ensure_installed, "shellcheck")
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      opts.sources = vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.write_good,
        nls.builtins.code_actions.shellcheck,
        nls.builtins.diagnostics.shellcheck,
        nls.builtins.diagnostics.markdownlint,
        nls.builtins.diagnostics.vale,
      })
    end,
  },
}
