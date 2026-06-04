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
    javascript = { 'oxfmt' },
    javascriptreact = { 'oxfmt' },
    typescript = { 'oxfmt' },
    typescriptreact = { 'oxfmt' },
  },
  formatters = {
    oxfmt = {
      command = 'oxfmt',
      args = { '--stdin-filename', '$FILENAME' },
      stdin = true,
    },
  },
})

vim.keymap.set('', '<leader>cf', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = 'Format buffer' })
