return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      ansiblels = {},
      bashls = {},
      dockerls = {},
      intelephense = {},
      terraformls = {},
      tflint = {},
      yamlls = {
        settings = {
          yaml = {
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
