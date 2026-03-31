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
  local grug = require('grug-far')
  local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
  grug.open({
    transient = true,
    prefills = {
      filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
    },
  })
end, { desc = 'Search and Replace' })
