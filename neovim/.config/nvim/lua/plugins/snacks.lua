return {
  "folke/snacks.nvim",
  opts = {
    dashboard = {
      enabled = true,
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
          exclude = { "node_modules", ".git", ".terraform", ".yarn" },
        },
        files = {
          hidden = true,
          ignored = true,
          exclude = { "node_modules", ".git", ".terraform" },
        },
        grep = {
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
