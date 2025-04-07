local COPILOT_REVIEW = string.format([[Your task is to review the provided code snippet.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
- Typos or grammatical errors in comments or strings.

Your feedback must be concise, directly addressing each identified issue with:
- A clear description of the problem.
- A concrete suggestion for how to improve or correct the issue.

Format your feedback as follows:
- Explain the high-level issue or problem briefly.
- Provide an example of how to fix each problem.
- Provide a specific suggestion for improvement.

If the code snippet has no readability issues, simply confirm that the code is clear and well-written as is.
]])
local COPILOT_REFACTOR = string.format(
  [[Your task is to refactor the provided code snippet, focusing specifically on its readability and maintainability.
Identify any issues related to:
- Naming conventions that are unclear, misleading or doesn't follow conventions for the language being used.
- The presence of unnecessary comments, or the lack of necessary ones.
- Overly complex expressions that could benefit from simplification.
- High nesting levels that make the code difficult to follow.
- The use of excessively long names for variables or functions.
- Any inconsistencies in naming, formatting, or overall coding style.
- Repetitive code patterns that could be more efficiently handled through abstraction or optimization.
]]
)
return {
  {
    "olimorris/codecompanion.nvim",
    cmd = { "CodeCompanion", "CodeCompanionActions", "CodeCompanionToggle", "CodeCompanionAdd", "CodeCompanionChat" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "saghen/blink.cmp", -- Optional: For using slash commands and variables in the chat buffer
      "ibhagwan/fzf-lua",
      "jellydn/spinner.nvim",
      { "stevearc/dressing.nvim", opts = {} }, -- Optional: Improves `vim.ui.select`
    },
    config = true,
    keys = {
      { "<leader>a", "", desc = "+ai", mode = { "n", "v" } },
      {
        "<leader>ap",
        "<cmd>CodeCompanionActions<cr>",
        mode = { "n", "v" },
        desc = "Prompt Actions (CodeCompanion)",
      },
      { "<leader>aa", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "Toggle (CodeCompanion)" },
      { "<leader>ac", "<cmd>CodeCompanionAdd<cr>", mode = "v", desc = "Add code to CodeCompanion" },
      {
        "<leader>ai",
        "<cmd>CodeCompanion<cr>",
        mode = "n",
        desc = "Inline prompt (CodeCompanion)",
      },
      {
        "<leader>ae",
        "<cmd>CodeCompanion /explain<cr>",
        mode = "v",
        desc = "Explain Code (CodeCompanion)",
      },
      { "<leader>af", "<cmd>CodeCompanion /fix<cr>", mode = "v", desc = "Fix Code (CodeCompanion)" },
      {
        "<leader>al",
        "<cmd>CodeCompanion /lsp<cr>",
        mode = { "n", "v" },
        desc = "Explain LSP Diagnostics (CodeCompanion)",
      },
      {
        "<leader>at",
        "<cmd>CodeCompanion /tests<cr>",
        mode = "v",
        desc = "Generate Tests (CodeCompanion)",
      },
      {
        "<leader>ad",
        "<cmd>CodeCompanion /inline-doc<cr>",
        mode = "v",
        desc = "Document Code Inline (CodeCompanion)",
      },
      {
        "<leader>aD",
        "<cmd>CodeCompanion /doc<cr>",
        mode = "v",
        desc = "Document Code Inline (CodeCompanion)",
      },
    },
    init = function()
      local spinner = require("spinner")
      local group = vim.api.nvim_create_augroup("CodeCompanionHooks", {})
      vim.api.nvim_create_autocmd({ "User" }, {
        pattern = "CodeCompanionRequest*",
        group = group,
        callback = function(request)
          if request.match == "CodeCompanionRequestStarted" then
            spinner.show()
          end
          if request.match == "CodeCompanionRequestFinished" then
            spinner.hide()
          end
        end,
      })
    end,
    opts = {
      adapters = {
        copilot = function()
          return require("codecompanion.adapters").extend("copilot", {
            schema = {
              model = {
                default = "claude-3.7-sonnet",
              },
            },
          })
        end,
      },
      display = {
        action_palette = {
          provider = "default",
        },
      },
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
              callback = "strategies.chat.slash_commands.buffer",
              opts = {
                provider = "snacks", -- default|telescope|mini_pick|fzf_lua|snacks
                contains_code = true,
              },
            },
            ["file"] = {
              opts = {
                provider = "snacks", -- default|telescope|mini_pick|fzf_lua|snacks
                contains_code = true,
              },
            },
            ["help"] = {
              opts = {
                provider = "snacks", -- default|telescope|mini_pick|fzf_lua|snacks
              },
            },
            ["symbols"] = {
              opts = {
                contains_code = true,
                provider = "snacks", -- default|telescope|mini_pick|fzf_lua|snacks
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
      prompt_library = {
        ["Inline Document"] = {
          strategy = "inline",
          description = "Add documentation for code.",
          opts = {
            modes = { "v" },
            short_name = "inline-doc",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please provide documentation in comment code for the following code and suggest to have better naming to improve readability.\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Document"] = {
          strategy = "chat",
          description = "Write documentation for code.",
          opts = {
            modes = { "v" },
            short_name = "doc",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please brief how it works and provide documentation in comment code for the following code. Also suggest to have better naming to improve readability.\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Review"] = {
          strategy = "chat",
          description = "Review the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "review",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = COPILOT_REVIEW,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Review Code"] = {
          strategy = "chat",
          description = "Review code and provide suggestions for improvement.",
          opts = {
            short_name = "review-code",
            auto_submit = false,
            is_slash_cmd = true,
          },
          prompts = {
            {
              role = "system",
              content = COPILOT_REVIEW,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = "Please review the following code and provide suggestions for improvement then refactor the following code to improve its clarity and readability.",
            },
          },
        },
        ["Code Review of Git Diff"] = {
          strategy = "chat",
          description = "Code review of git diff",
          opts = {
            modes = { "n" },
            is_slash_cmd = true,
            short_name = "git-diff-review",
            auto_submit = true,
          },
          prompts = {
            {
              role = "system",
              content = COPILOT_REVIEW,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function()
                return string.format(
                  [[ Perform a code review of the git diff. Be sure to call out any spelling mistakes, bugs, errors, and other key areas of concern. Provide useful suggestions for fixes and improvements:"
```diff
%s
```]],
                  vim.fn.system(
                    "git diff $(git merge-base $(git symbolic-ref refs/remotes/origin/HEAD | sed 's@^refs/remotes/origin/@@') HEAD) "
                  )
                )
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Refactor"] = {
          strategy = "inline",
          description = "Refactor the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "refactor",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "system",
              content = COPILOT_REFACTOR,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please refactor the following code to improve its clarity and readability:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Refactor Code"] = {
          strategy = "chat",
          description = "Refactor the provided code snippet.",
          opts = {
            short_name = "refactor-code",
            auto_submit = false,
            is_slash_cmd = true,
          },
          prompts = {
            {
              role = "system",
              content = COPILOT_REFACTOR,
              opts = {
                visible = false,
              },
            },
            {
              role = "user",
              content = "Please refactor the following code to improve its clarity and readability.",
            },
          },
        },
        ["Naming"] = {
          strategy = "inline",
          description = "Give betting naming for the provided code snippet.",
          opts = {
            modes = { "v" },
            short_name = "naming",
            auto_submit = true,
            user_prompt = false,
            stop_context_insertion = true,
          },
          prompts = {
            {
              role = "user",
              content = function(context)
                local code = require("codecompanion.helpers.actions").get_code(context.start_line, context.end_line)

                return "Please provide better names for the following variables and functions:\n\n```"
                  .. context.filetype
                  .. "\n"
                  .. code
                  .. "\n```\n\n"
              end,
              opts = {
                contains_code = true,
              },
            },
          },
        },
        ["Better Naming"] = {
          strategy = "chat",
          description = "Give betting naming for the provided code snippet.",
          opts = {
            short_name = "better-naming",
            auto_submit = false,
            is_slash_cmd = true,
          },
          prompts = {
            {
              role = "user",
              content = "Please provide better names for the following variables and functions.",
            },
          },
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
