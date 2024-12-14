return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "saghen/blink.cmp", -- Optional: For using slash commands and variables in the chat buffer
    "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
    { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
  },
  config = true,
  opts = {
    strategies = {
      chat = {
        adapter = "copilot",
        slash_commands = {
          ["buffer"] = {
            opts = {
              provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["file"] = {
            opts = {
              provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
            },
          },
          ["help"] = {
            opts = {
              provider = "fzf_lua", -- telescope|mini_pick|fzf_lua
            },
          },
          ["symbols"] = {
            opts = {
              contains_code = true,
              provider = "fzf_lua", -- default|telescope|mini_pick|fzf_lua
            },
          },
        },
      },
      inline = {
        adapter = "copilot",
      },
      agent = {
        adapter = "copilot",
      },
    },
  },
}
