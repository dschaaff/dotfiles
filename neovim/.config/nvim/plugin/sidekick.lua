require('sidekick').setup({
  nes = {
    enabled = false,
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>acc', function()
  require('sidekick.cli').toggle({ name = 'claude', focus = true })
end, { desc = 'Sidekick Claude Toggle' })

vim.keymap.set({ 'n', 'v' }, '<leader>acg', function()
  require('sidekick.cli').toggle({ name = 'gemini', focus = true })
end, { desc = 'Sidekick Grok Toggle' })
