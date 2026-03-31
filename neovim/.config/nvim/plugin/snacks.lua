---@type snacks.Config
require('snacks').setup({
  lazygit = { enabled = true },
})

vim.keymap.set('n', '<leader>gg', function()
  require('snacks').lazygit()
end, { desc = 'LazyGit' })
