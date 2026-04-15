-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = false

-- [[ Setting options ]]
require('options')

require('keymaps')

require('autocommands')

-- [[ PackChanged hooks (must be defined before vim.pack.add) ]]
vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name = ev.data.spec.name
    local kind = ev.data.kind
    if kind ~= 'install' and kind ~= 'update' then
      return
    end
    if name == 'nvim-treesitter' then
      vim.cmd('TSUpdate')
    elseif name == 'LuaSnip' then
      local path = vim.fn.stdpath('data') .. '/site/pack/core/opt/LuaSnip'
      vim.fn.system({ 'make', '-C', path, 'install_jsregexp' })
    elseif name == 'markdown-preview.nvim' then
      vim.cmd.packadd('markdown-preview.nvim')
      vim.fn['mkdp#util#install']()
    end
  end,
})

-- [[ Register all plugins with vim.pack ]]
-- plugin/*.lua files auto-execute and handle all setup() calls
vim.pack.add({
  -- foundations
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/folke/tokyonight.nvim',
  'https://github.com/folke/snacks.nvim',
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim',
  -- completion + snippets
  'https://github.com/rafamadriz/friendly-snippets',
  { src = 'https://github.com/L3MON4D3/LuaSnip', version = vim.version.range('2.x') },
  'https://github.com/folke/lazydev.nvim',
  { src = 'https://github.com/saghen/blink.cmp', version = vim.version.range('1.x') },
  -- lsp
  'https://github.com/j-hui/fidget.nvim',
  'https://github.com/b0o/SchemaStore.nvim',
  'https://github.com/mason-org/mason.nvim',
  'https://github.com/mason-org/mason-lspconfig.nvim',
  'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',
  'https://github.com/neovim/nvim-lspconfig',
  -- file tree
  'https://github.com/nvim-neo-tree/neo-tree.nvim',
  'https://github.com/antosha417/nvim-lsp-file-operations',
  -- git
  'https://github.com/lewis6991/gitsigns.nvim',
  'https://github.com/tpope/vim-fugitive',
  'https://github.com/farhanmustar/fugitive-delta.nvim',
  -- diff + database
  'https://github.com/dlyongemallo/diffview.nvim',
  'https://github.com/tpope/vim-dadbod',
  'https://github.com/kristijanhusak/vim-dadbod-ui',
  'https://github.com/kristijanhusak/vim-dadbod-completion',
  -- search + edit
  'https://github.com/ibhagwan/fzf-lua',
  'https://github.com/stevearc/conform.nvim',
  'https://github.com/mfussenegger/nvim-lint',
  'https://github.com/MagicDuck/grug-far.nvim',

  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/lukas-reineke/indent-blankline.nvim',
  'https://github.com/NMAC427/guess-indent.nvim',
  'https://github.com/rhysd/committia.vim',
  'https://github.com/tpope/vim-rsi', -- readline insertion
  'https://github.com/cappyzawa/starlark.vim',
  'https://github.com/towolf/vim-helm',
  'https://github.com/stevearc/dressing.nvim',
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  -- ai
  'https://github.com/olimorris/codecompanion.nvim',
  'https://github.com/folke/sidekick.nvim',
})

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
