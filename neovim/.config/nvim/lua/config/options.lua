# ensure dockerfile filetype set correctly
vim.filetype.add({
  pattern = {
    ["Dockerfile.*"] = {"dockerfile",{ priority = 10 }},
  },
})
-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
-- don't hide quotes and other markup in json etc.
vim.opt.conceallevel = 0

-- set some neovide specific settings
vim.o.guifont = "JetBrains Mono,Symbols Nerd Font:h13"
vim.g.neovide_cursor_animation_length = 0
vim.g.neovide_remember_window_size = true
if vim.g.neovide then
  vim.keymap.set('n', '<D-s>', ':w<CR>') -- Save
  vim.keymap.set('v', '<D-c>', '"+y') -- Copy
  vim.keymap.set('n', '<D-v>', '"+P') -- Paste normal mode
  vim.keymap.set('v', '<D-v>', '"+P') -- Paste visual mode
  vim.keymap.set('c', '<D-v>', '<C-R>+') -- Paste command mode
  vim.keymap.set('i', '<D-v>', '<ESC>l"+Pli') -- Paste insert mode
end
