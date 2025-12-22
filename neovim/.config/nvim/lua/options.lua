-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!
--  For more options, you can see `:help option-list`

-- Make line numbers default
vim.o.number = true
vim.o.relativenumber = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.o.mouse = 'a'

vim.o.tabstop = 2 -- Number of spaces a tab counts for
vim.o.shiftwidth = 2 -- Number of spaces for each step of (auto)indent
vim.o.softtabstop = 2 -- Number of spaces a tab counts for while editing
vim.o.expandtab = true -- Use spaces instead of tabs
vim.o.smartindent = true -- Smart autoindenting when starting a new line
vim.o.autoindent = true -- Copy indent from current line when starting new line
vim.o.shiftround = true -- Round indent to multiple of shiftwidth
vim.o.showmode = false -- Don't show the mode, since it's already in the status line
vim.o.undofile = true
vim.o.undolevels = 1000
vim.o.shada = "'100,<50,s10,:1000,/100,@100,h" -- Limit ShaDa file (for startup)
vim.o.shortmess = 'CFOSWaco' -- Disable some built-in completion messages
-- Sync clipboard between OS and Neovim.
--  Schedule the setting after `UiEnter` because it can increase startup-time.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- Pattern for a start of numbered list (used in `gw`). This reads as
-- "Start of list item is: at least one special character (digit, -, +, *)
-- possibly followed by punctuation (. or `)`) followed by at least one space".
vim.o.formatlistpat = [[^\s*[0-9\-\+\*]\+[\.\)]*\s\+]]

vim.o.iskeyword = '@,48-57,_,192-255,-' -- Treat dash as `word` textobject part

-- check my typos :)
vim.o.spell = true

-- Enable break indent
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default, less redraw flicker
vim.o.signcolumn = 'yes'

-- Decrease update time
vim.o.updatetime = 250

-- Decrease mapped sequence wait time
vim.o.timeoutlen = 300

-- Configure how new splits should be opened
vim.o.splitright = true
vim.o.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
--
--  Notice listchars is set using `vim.opt` instead of `vim.o`.
--  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
--   See `:help lua-options`
--   and `:help lua-options-guide`
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.o.inccommand = 'split'

-- Show which line your cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
-- See `:help 'confirm'`
vim.o.confirm = true

-- don't hide quotes and other markup in json etc.
vim.opt.conceallevel = 0

-- ensure dockerfile filetype set correctly
vim.filetype.add({
  pattern = {
    ['Dockerfile.*'] = { 'dockerfile', { priority = 10 } },
  },
})
-- set some neovide specific settings
vim.o.guifont = 'JetBrains Mono,Symbols Nerd Font:h13'
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_remember_window_size = true
if vim.g.neovide then
  vim.opt.title = true
  vim.opt.titlestring = '%t - %F'
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
-- The LSP logfile continually grows in size when enabled
-- only enable when need to debug
vim.lsp.set_log_level('off')

-- Use bedrock in claude code, launched via sidekick
vim.env.CLAUDE_CODE_USE_BEDROCK = '1'
-- vim: ts=2 sts=2 sw=2 et
