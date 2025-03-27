return {
  {
    "zbirenbaum/copilot.lua",
    opts = {
      filetypes = {
        helm = true,
        yaml = true,
        terraform = true,
        markdown = true,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
      },
      copilot_model = "gpt-4o-copilot", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
    },
  },
}
