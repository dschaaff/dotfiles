local cmdline = false
local M = {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		{ "hrsh7th/cmp-cmdline", enabled = cmdline },
		{ "dmitmel/cmp-cmdline-history", enabled = cmdline },
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
	},
	"hrsh7th/cmp-nvim-lsp",
	'L3MON4D3/LuaSnip',
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",
	"dmitmel/cmp-cmdline-history",
	"hrsh7th/cmp-path",
	"saadparwaiz1/cmp_luasnip",
	'onsails/lspkind.nvim',
}

function M.config()
	-- Set completeopt to have a better completion experience
	vim.o.completeopt = "menuone,noselect"

	-- Setup nvim-cmp.
	local cmp = require("cmp")
	local lspkind = require('lspkind')
	local luasnip = require 'luasnip'

	cmp.setup({
		completion = {
			completeopt = "menu,menuone,noinsert",
		},
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		mapping = cmp.mapping.preset.insert({
			["<C-n>"] = cmp.mapping.select_next_item { behavior = cmp.SelectBehavior.Insert },
			["<C-p>"] = cmp.mapping.select_prev_item { behavior = cmp.SelectBehavior.Insert },
			['<C-b>'] = cmp.mapping.scroll_docs(-4),
			['<C-f>'] = cmp.mapping.scroll_docs(4),
			['<C-Space>'] = cmp.mapping.complete(),
			['<C-e>'] = cmp.mapping.abort(),
			['<CR>'] = cmp.mapping.confirm({ select = true }),
		}),
		sources = cmp.config.sources({
			{ name = "nvim_lsp" },
			{ name = "luasnip" },
			{ name = "buffer" },
			{ name = "path" },
		}),
		formatting = {
			format = lspkind.cmp_format({
				mode = "symbol_text",
				menu = ({
					buffer = "[Buffer]",
					nvim_lsp = "[LSP]",
					luasnip = "[LuaSnip]",
					nvim_lua = "[Lua]",
					latex_symbols = "[Latex]",
				})
			}),
		},
		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
			}, {
				{ name = 'buffer' },
			})
		}),
		-- documentation = {
		--   border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
		--   winhighlight = "NormalFloat:NormalFloat,FloatBorder:TelescopeBorder",
		-- },
		experimental = {
			ghost_text = {
				hl_group = "LspCodeLens",
			},
		},
		-- sorting = {
		--   comparators = {
		--     cmp.config.compare.sort_text,
		--     cmp.config.compare.offset,
		--     -- cmp.config.compare.exact,
		--     cmp.config.compare.score,
		--     -- cmp.config.compare.kind,
		--     -- cmp.config.compare.length,
		--     cmp.config.compare.order,
		--   },
		-- },
	})
	-- if cmdline then
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			-- { name = "noice_popupmenu" },
			{ name = "path" },
			{ name = "cmdline" },
			-- { name = "cmdline_history" },
		}),
	})
	-- end
	-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline('/', {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = 'buffer' }
		}
	})
end

return M
