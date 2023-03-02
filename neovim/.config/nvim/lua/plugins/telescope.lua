-- local function project_files()
-- 	local opts = {}
-- 	if vim.loop.fs_stat(".git") then
-- 		opts.show_untracked = true
-- 		require("telescope.builtin").git_files(opts)
-- 	else
-- 		local client = vim.lsp.get_active_clients()[1]
-- 		if client then
-- 			opts.cwd = client.config.root_dir
-- 		end
-- 		require("telescope.builtin").find_files(opts)
-- 	end
-- end

return {
	"nvim-telescope/telescope.nvim",
	cmd = { "Telescope" },

	dependencies = {
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
	-- keys = {
	-- 	{ "<leader><space>", project_files, desc = "Find File" },
	-- },
	config = function()
		-- local actions = require("telescope.actions")

		local telescope = require("telescope")
		local borderless = true
		telescope.setup({
			defaults = {
				-- Default configuration for telescope goes here:
				-- config_key = value,
				mappings = {
					--   i = {
					--     -- map actions.which_key to <C-h> (default: <C-/>)
					--     -- actions.which_key shows the mappings for your picker,
					--     -- e.g. git_{create, delete, ...}_branch for the git_branches picker
					--     ["<C-h>"] = "which_key"
					--   }
				}
			},
			pickers = {
				live_grep = {
					additional_args = function(opts)
						return { "--hidden" }
					end
				}
			},
			extensions = {
				-- Your extension configuration goes here:
				-- extension_name = {
				--   extension_config_key = value,
				-- }
				-- please take a look at the readme of the extension you want to configure
			}
		})
		telescope.load_extension("fzf")
	end,
	vim.keymap.set('n', '<C-p>', ':Telescope find_files<CR>', { desc = 'search files' }),
	vim.keymap.set('n', '<C-b>', ':Telescope buffers<CR>', { desc = 'search buffers' }),
	vim.keymap.set('n', '<leader>sg', ':Telescope live_grep<CR>', { desc = '[S]earch by [G]rep' }),
	vim.keymap.set('n', '<leader>ss', ':Telescope spell_suggest<CR>', { desc = '[S]pell [S]uggest' })
}
