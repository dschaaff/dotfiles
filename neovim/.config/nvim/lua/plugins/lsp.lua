return {
  "neovim/nvim-lspconfig",
  enabled = not vim.g.vscode,
  opts = {
    servers = {
      ansiblels = {},
      bashls = {},
      dockerls = {},
      intelephense = {},
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
            completion = true,
            hover = true,
          },
        },
      },
    },
  },
}
