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
