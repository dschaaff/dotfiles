require('conform').setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 3000,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    sh = { 'shfmt' },
    markdown = { 'prettierd', 'prettier', stop_after_first = true },
    python = { 'ruff_organize_imports', 'ruff_format' },
    javascript = { 'oxlint_fix', 'oxfmt' },
    javascriptreact = { 'oxlint_fix', 'oxfmt' },
    typescript = { 'oxlint_fix', 'oxfmt' },
    typescriptreact = { 'oxlint_fix', 'oxfmt' },
  },
  formatters = {
    oxfmt = {
      command = 'oxfmt',
      args = { '--stdin-filename', '$FILENAME' },
      stdin = true,
    },
    oxlint_fix = {
      command = 'oxlint',
      args = { '--fix', '$FILENAME' },
      stdin = false,
    },
  },
})

vim.keymap.set('', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })
