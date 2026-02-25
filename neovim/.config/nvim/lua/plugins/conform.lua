return {
  { -- Autoformat
    'stevearc/conform.nvim',
    enabled = not vim.g.vscode,
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>cf',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
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
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
