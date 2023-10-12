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
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = {
        markdown = { "vale", "markdownlint" },
        sh = { "shellcheck" },
      },
    },
  },
}
