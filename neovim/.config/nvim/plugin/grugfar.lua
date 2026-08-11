require('grug-far').setup({
  engines = {
    ripgrep = {
      extraArgs = '--hidden --glob !.git/ --glob !.terraform --glob !node_modules --glob !.DS_Store',
    },
  },
  keymaps = {
    close = { n = 'q' },
  },
})

vim.keymap.set({ 'n', 'v' }, '<leader>sr', function()
  require('grug-far').open({ transient = true })
end, { desc = 'Search and Replace (project)' })

vim.keymap.set({ 'n', 'v' }, '<leader>sR', function()
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  require('grug-far').open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  })
end, { desc = 'Search and Replace (current file type)' })
