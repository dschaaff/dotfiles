-- Markdown Preview: command stubs
local mdp_cmds = { 'MarkdownPreview', 'MarkdownPreviewToggle', 'MarkdownPreviewStop' }
for _, cmd in ipairs(mdp_cmds) do
  vim.api.nvim_create_user_command(cmd, function(opts)
    for _, c in ipairs(mdp_cmds) do
      pcall(vim.api.nvim_del_user_command, c)
    end
    vim.pack.add({ 'https://github.com/iamcco/markdown-preview.nvim' })
    vim.cmd([[do FileType]])
    vim.cmd(cmd .. ' ' .. (opts.args or ''))
  end, { nargs = '*' })
end

-- Markdown Preview keymap (only in markdown buffers)
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  callback = function(ev)
    vim.keymap.set('n', '<leader>cp', '<cmd>MarkdownPreviewToggle<cr>', { buffer = ev.buf, desc = 'Markdown Preview' })
  end,
})

-- markdown-toc: load on markdown filetype
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'markdown',
  once = true,
  callback = function()
    vim.pack.add({ 'https://github.com/hedyhli/markdown-toc.nvim' })
    require('mtoc').setup({
      auto_update = { enabled = true },
    })
  end,
})
