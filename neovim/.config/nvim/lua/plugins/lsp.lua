return {
  "neovim/nvim-lspconfig",
  enabled = not vim.g.vscode,
  opts = {
    servers = {
      ansiblels = {},
      bashls = {},
      intelephense = {},
      terraformls = {},
      tflint = {},
      yamlls = {
        settings = {
          yaml = {
            customTags = {
              "!reference sequence",
            },
            schemaStore = {
              enable = true,
            },
            keyOrdering = {
              enable = false,
            },
          },
        },
      },
    },
  },
}
