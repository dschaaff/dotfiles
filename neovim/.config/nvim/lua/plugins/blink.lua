return {
  "saghen/blink.cmp",
  dependencies = {
    "olimorris/codecompanion.nvim",
  },
  opts = {
    -- keymap = { preset = "default" },
    sources = {
      default = { "codecompanion" },
      providers = {
        codecompanion = {
          name = "CodeCompanion",
          module = "codecompanion.providers.completion.blink",
          enabled = true,
        },
      },
    },
  },
}
