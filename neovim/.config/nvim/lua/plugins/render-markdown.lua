return {
  'MeanderingProgrammer/render-markdown.nvim',
  dependencies = { 'nvim-treesitter/nvim-treesitter', 'nvim-mini/mini.icons' }, -- if you use standalone mini plugins
  opts = {
    code = {
      sign = false,
      width = 'block',
      right_pad = 1,
    },
    heading = {
      sign = false,
      icons = {},
    },
    checkbox = {
      enabled = false,
    },
  },
  ft = { 'markdown', 'norg', 'rmd', 'org', 'codecompanion' },
  config = function()
    require('render-markdown').setup({
      completions = { lsp = { enabled = true } },
      overrides = {
        filetype = {
          codecompanion = {
            render_modes = true,
            sign = { enabled = false },
            html = {
              tag = {
                buf = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
                file = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
                group = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
                help = { icon = '󰘥 ', highlight = 'CodeCompanionChatIcon' },
                image = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
                symbols = { icon = ' ', highlight = 'CodeCompanionChatIcon' },
                tool = { icon = '󰯠 ', highlight = 'CodeCompanionChatIcon' },
                url = { icon = '󰌹 ', highlight = 'CodeCompanionChatIcon' },
              },
            },
          },
        },
      },
    })
  end,
}
