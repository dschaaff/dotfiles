return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "saghen/blink.cmp", -- Optional: For using slash commands and variables in the chat buffer
      "nvim-telescope/telescope.nvim", -- Optional: For using slash commands
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = true,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      { "<leader>ap", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "Prompt Actions (CodeCompanion)" },
      { "<leader>aa", "<cmd>CodeCompanionChat<cr>", mode = { "n", "v" }, desc = "Open CodeCompanion" },
      { "<leader>ac", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add code to CodeCompanion" },
      { "<leader>ai", "<cmd>CodeCompanion<cr>", mode = "n", desc = "Inline prompt (CodeCompanion)" },
    },
    opts = {
      strategies = {
        chat = {
          adapter = "copilot",
          roles = {
            llm = "  CodeCompanion", -- The markdown header content for the LLM's responses
            user = "  Me", -- The markdown header for your questions
          },
          -- keymaps = {
          --   close = {
          --     modes = {
          --       n = "q",
          --       i = "<Esc>",
          --     },
          --   },
          -- },
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
  },
  {
    "folke/edgy.nvim",
    optional = true,
    opts = function(_, opts)
      opts.right = opts.right or {}
      table.insert(opts.right, {
        ft = "codecompanion",
        title = "CodeCompanion Chat",
        size = { width = 50 },
      })
    end,
  },
}
