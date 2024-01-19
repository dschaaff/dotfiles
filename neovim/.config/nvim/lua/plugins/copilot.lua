return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
    enabled = not vim.g.vscode,
		build = ":Copilot auth",
		opts = {
			suggestion = { enabled = false },
			panel = { enabled = false },
			filetypes = {
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
		},
	}
}
-- vim: ts=2 sts=2 sw=2 et
