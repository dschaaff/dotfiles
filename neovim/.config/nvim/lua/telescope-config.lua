require('telescope').setup{
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
                return {"--hidden"}
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
}

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
