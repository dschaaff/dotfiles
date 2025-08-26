return {
  'mfussenegger/nvim-lint',
  event = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
  config = function()
    local lint = require('lint')

    lint.linters_by_ft = {
      markdown = { 'vale', 'markdownlint' },
      sh = { 'shellcheck' },
      dockerfile = { 'hadolint' },
    }

    lint.linters.markdownlint.args = { '--disable', 'MD043', '--disable', 'MD013', '--' }

    -- vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost', 'InsertLeave' }, {
    --   callback = function()
    --     lint.try_lint()
    --   end,
    -- })
  end,
}
