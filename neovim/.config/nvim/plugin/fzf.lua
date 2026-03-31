require('fzf-lua').setup({
  defaults = {
    prompt = '❯ ',
  },
  files = {
    cwd_prompt = false,
    prompt = '❯ ',
  },
  winopts = {
    preview = {
      hidden = true,
      layout = 'horizontal',
    },
  },
  keymap = {
    builtin = {
      ['<c-f>'] = 'preview-page-down',
      ['<c-b>'] = 'preview-page-up',
      ['<M-p>'] = 'toggle-preview',
    },
    fzf = {
      ['ctrl-q'] = 'select-all+accept',
      ['ctrl-u'] = 'half-page-up',
      ['ctrl-d'] = 'half-page-down',
      ['ctrl-x'] = 'jump',
      ['ctrl-f'] = 'preview-page-down',
      ['ctrl-b'] = 'preview-page-up',
    },
  },
})

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'fzf',
  callback = function(ev)
    vim.keymap.set('t', '<c-j>', '<c-j>', { buffer = ev.buf, nowait = true })
    vim.keymap.set('t', '<c-k>', '<c-k>', { buffer = ev.buf, nowait = true })
  end,
})
vim.keymap.set('n', '<leader>,', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', { desc = 'Switch Buffer' })
vim.keymap.set('n', '<leader>:', '<cmd>FzfLua command_history<cr>', { desc = 'Command History' })
vim.keymap.set('n', '<leader><space>', '<cmd>FzfLua files<cr>', { desc = 'Find Files' })
-- find
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers sort_mru=true sort_lastused=true<cr>', { desc = 'Buffers' })
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<cr>', { desc = 'Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua git_files<cr>', { desc = 'Find Files (git-files)' })
vim.keymap.set('n', '<leader>fr', '<cmd>FzfLua oldfiles<cr>', { desc = 'Recent' })
-- git
vim.keymap.set('n', '<leader>gc', '<cmd>FzfLua git_commits<CR>', { desc = 'Commits' })
vim.keymap.set('n', '<leader>gs', '<cmd>FzfLua git_status<CR>', { desc = 'Status' })
-- search
vim.keymap.set('n', '<leader>s"', '<cmd>FzfLua registers<cr>', { desc = 'Registers' })
vim.keymap.set('n', '<leader>sa', '<cmd>FzfLua autocmds<cr>', { desc = 'Auto Commands' })
vim.keymap.set('n', '<leader>sb', '<cmd>FzfLua grep_curbuf<cr>', { desc = 'Buffer' })
vim.keymap.set('n', '<leader>sc', '<cmd>FzfLua command_history<cr>', { desc = 'Command History' })
vim.keymap.set('n', '<leader>sC', '<cmd>FzfLua commands<cr>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>sd', '<cmd>FzfLua diagnostics_document<cr>', { desc = 'Document Diagnostics' })
vim.keymap.set('n', '<leader>sD', '<cmd>FzfLua diagnostics_workspace<cr>', { desc = 'Workspace Diagnostics' })
vim.keymap.set('n', '<leader>sg', '<cmd>FzfLua live_grep<cr>', { desc = 'Grep' })
vim.keymap.set('n', '<leader>sh', '<cmd>FzfLua help_tags<cr>', { desc = 'Help Pages' })
vim.keymap.set('n', '<leader>sH', '<cmd>FzfLua highlights<cr>', { desc = 'Search Highlight Groups' })
vim.keymap.set('n', '<leader>sj', '<cmd>FzfLua jumps<cr>', { desc = 'Jumplist' })
vim.keymap.set('n', '<leader>sk', '<cmd>FzfLua keymaps<cr>', { desc = 'Key Maps' })
vim.keymap.set('n', '<leader>sl', '<cmd>FzfLua loclist<cr>', { desc = 'Location List' })
vim.keymap.set('n', '<leader>sM', '<cmd>FzfLua man_pages<cr>', { desc = 'Man Pages' })
vim.keymap.set('n', '<leader>sm', '<cmd>FzfLua marks<cr>', { desc = 'Jump to Mark' })
vim.keymap.set('n', '<leader>sR', '<cmd>FzfLua resume<cr>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>sq', '<cmd>FzfLua quickfix<cr>', { desc = 'Quickfix List' })
