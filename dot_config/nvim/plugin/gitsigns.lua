require('gitsigns').setup({
  signs = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
    untracked = { text = '▎' },
  },
  signs_staged = {
    add = { text = '▎' },
    change = { text = '▎' },
    delete = { text = '' },
    topdelete = { text = '' },
    changedelete = { text = '▎' },
  },
})

vim.keymap.set('n', ']h', function()
  if vim.wo.diff then
    return vim.cmd.normal({ ']c', bang = true })
  else
    return require('gitsigns').nav_hunk('next')
  end
end, { desc = 'Next Hunk' })

vim.keymap.set('n', '[h', function()
  if vim.wo.diff then
    return vim.cmd.normal({ '[c', bang = true })
  else
    return require('gitsigns').nav_hunk('prev')
  end
end, { desc = 'Prev Hunk' })

vim.keymap.set('n', ']H', function()
  return require('gitsigns').nav_hunk('last')
end, { desc = 'Last Hunk' })

vim.keymap.set('n', '[H', function()
  return require('gitsigns').nav_hunk('first')
end, { desc = 'First Hunk' })

vim.keymap.set({ 'n', 'v' }, '<leader>ghs', ':Gitsigns stage_hunk<CR>', { desc = 'Stage Hunk' })
vim.keymap.set({ 'n', 'v' }, '<leader>ghr', ':Gitsigns reset_hunk<CR>', { desc = 'Reset Hunk' })

vim.keymap.set('n', '<leader>ghS', function()
  return require('gitsigns').stage_buffer()
end, { desc = 'Stage Buffer' })

vim.keymap.set({ 'n', 'v' }, '<leader>ghu', ':Gitsigns stage_hunk<CR>', { desc = 'Unstage Hunk' })

vim.keymap.set('n', '<leader>ghR', function()
  return require('gitsigns').reset_buffer()
end, { desc = 'Reset Buffer' })

vim.keymap.set('n', '<leader>ghp', function()
  return require('gitsigns').preview_hunk_inline()
end, { desc = 'Preview Hunk Inline' })

vim.keymap.set('n', '<leader>ghb', function()
  return require('gitsigns').blame_line({ full = true })
end, { desc = 'Blame Line' })

vim.keymap.set('n', '<leader>ghB', function()
  return require('gitsigns').blame()
end, { desc = 'Blame Buffer' })

vim.keymap.set('n', '<leader>ghd', function()
  return require('gitsigns').diffthis()
end, { desc = 'Diff This' })

vim.keymap.set('n', '<leader>ghD', function()
  return require('gitsigns').diffthis('~')
end, { desc = 'Diff This ~' })

vim.keymap.set({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'GitSigns Select Hunk' })
