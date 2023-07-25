return {
  "neovim/nvim-lspconfig",
  enabled = not vim.g.vscode,
  dependencies = {
    "b0o/SchemaStore.nvim",
    version = false, -- last release is way too old
  },
  opts = {
    servers = {
      ansiblels = {},
      bashls = {},
      dockerls = {},
      intelephense = {},
      tflint = {},
      yamlls = {
        -- lazy-load schemastore when needed
        on_new_config = function(new_config)
          new_config.settings.yaml.schemas = new_config.settings.yaml.schemas or {}
          vim.list_extend(new_config.settings.yaml.schemas, require("schemastore").yaml.schemas())
        end,
        settings = {
          yaml = {
            customTags = {
              "!reference sequence",
            },
            format = {
              enable = true,
            },
            validate = {
              -- Must disable built-in schemaStore support to use
              -- schemas from SchemaStore.nvim plugin
              enable = false,
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
