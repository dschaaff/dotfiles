---@type snacks.Config
require('snacks').setup({
  gitbrowse = { enabled = true },
  lazygit = { enabled = true },
})

vim.keymap.set('n', '<leader>gg', function()
  require('snacks').lazygit()
end, { desc = 'LazyGit' })

vim.keymap.set({ 'n', 'v' }, '<leader>gB', function()
  require('snacks').gitbrowse()
end, { desc = 'Open in browser' })
