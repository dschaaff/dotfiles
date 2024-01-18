-- [[ Setting options ]]
-- See `:help vim.o`
local opt = vim.opt
opt.hlsearch = false -- Set highlight on search
opt.number = true -- Make line numbers default
opt.relativenumber = true -- Use relative line numbers
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.mouse = 'a'      -- Enable mouse mode
opt.confirm = true    -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true  -- Use spaces instead of tabs
opt.list = true       -- Show some invisible characters (tabs...
opt.scrolloff = 4         -- Lines of context
opt.showmode = false      -- Dont show mode since we have a statusline
-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
opt.clipboard = 'unnamedplus'
opt.breakindent = true -- Enable break indent
opt.undofile = true -- Save undo history
opt.undolevels = 10000
-- Case-insensitive searching UNLESS \C or capital in search
opt.ignorecase = true
opt.smartcase = true -- Don't ignore case with capitals
opt.signcolumn = 'yes' -- Keep signcolumn on by default
opt.sidescrolloff = 8     -- Columns of context
opt.smartindent = true -- Insert indents automatically
opt.spelllang = { "en" }
opt.tabstop = 2        -- Number of spaces tabs count for

-- Decrease update time
opt.updatetime = 200
opt.timeoutlen = 300

opt.completeopt = 'menuone,noselect' -- Set completeopt to have a better completion experience
opt.wildmode = "longest:full,full"   -- Command-line completion mode
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}
-- ensure dockerfile filetype set correctly
vim.filetype.add({
  pattern = {
    ["Dockerfile.*"] = {"dockerfile",{ priority = 10 }},
  },
})
if vim.fn.has("nvim-0.10") == 1 then
  opt.smoothscroll = true
end
-- Enable LazyVim auto format
vim.g.autoformat = true
opt.formatoptions = "jcroqlnt" -- tcqj
vim.g.markdown_recommended_style = 0 -- Fix markdown indentation settings

vim.opt.conceallevel = 0             -- don't hide quotes and other markup in json etc.

-- set some neovide specific settings
opt.guifont = "JetBrains Mono,Symbols Nerd Font:h13"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_remember_window_size = true
if vim.g.neovide then
  vim.opt.title= true
  vim.opt.titlestring = "%t - %F"
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end

-- vim: ts=2 sts=2 sw=2 et
