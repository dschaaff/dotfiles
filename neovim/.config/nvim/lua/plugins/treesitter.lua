return {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "bash",
      "c",
      "go",
      "gomod",
      "hcl",
      "html",
      "javascript",
      "json",
      "jsonnet",
      "lua",
      "luap",
      "markdown",
      "markdown_inline",
      "php",
      "python",
      "query",
      "regex",
      "terraform",
      "tsx",
      "typescript",
      "vim",
      "yaml",
    })
  end,
}
