return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = false,
      preset = {
        header = [[

   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
    },
    picker = {
      sources = {
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", ".terraform" },
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", ".terraform" },
        },
      },
      formatters = {
        file = {
          filename_first = true,
          truncate = 100,
        },
      },
    },
  },
}
