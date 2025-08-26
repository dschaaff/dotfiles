-- Alternatively, use `config = function() ... end` for full control over the configuration.
-- If you prefer to call `setup` explicitly, use:
--    {
--        'lewis6991/gitsigns.nvim',
--        config = function()
--            require('gitsigns').setup({
--                -- Your gitsigns configuration here
--            })
--        end,
--    }
--
-- Here is a more advanced example where we pass configuration
-- options to `gitsigns.nvim`.
--
-- See `:help gitsigns` to understand what the configuration keys do
return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPost', 'BufWritePost', 'BufNewFile' },
    keys = {
      {
        ']h',
        function()
          if vim.wo.diff then
            return vim.cmd.normal({ ']c', bang = true })
          else
            return require('gitsigns').nav_hunk('next')
          end
        end,
        desc = 'Next Hunk',
      },
      {
        '[h',
        function()
          if vim.wo.diff then
            return vim.cmd.normal({ '[c', bang = true })
          else
            return require('gitsigns').nav_hunk('prev')
          end
        end,
        desc = 'Prev Hunk',
      },
      {
        ']H',
        function()
          return require('gitsigns').nav_hunk('last')
        end,
        desc = 'Last Hunk',
      },
      {
        '[H',
        function()
          return require('gitsigns').nav_hunk('first')
        end,
        desc = 'First Hunk',
      },
      { '<leader>ghs', ':Gitsigns stage_hunk<CR>', desc = 'Stage Hunk', mode = { 'n', 'v' } },
      { '<leader>ghr', ':Gitsigns reset_hunk<CR>', desc = 'Reset Hunk', mode = { 'n', 'v' } },
      {
        '<leader>ghS',
        function()
          return require('gitsigns').stage_buffer()
        end,
        desc = 'Stage Buffer',
      },
      { '<leader>ghu', ':Gitsigns stage_hunk<CR>', desc = 'Unstage Hunk', mode = { 'n', 'v' } },
      {
        '<leader>ghR',
        function()
          return require('gitsigns').reset_buffer()
        end,
        desc = 'Reset Buffer',
      },
      {
        '<leader>ghp',
        function()
          return require('gitsigns').preview_hunk_inline()
        end,
        desc = 'Preview Hunk Inline',
      },
      {
        '<leader>ghb',
        function()
          return require('gitsigns').blame_line({ full = true })
        end,
        desc = 'Blame Line',
      },
      {
        '<leader>ghB',
        function()
          return require('gitsigns').blame()
        end,
        desc = 'Blame Buffer',
      },
      {
        '<leader>ghd',
        function()
          return require('gitsigns').diffthis()
        end,
        desc = 'Diff This',
      },
      {
        '<leader>ghD',
        function()
          return require('gitsigns').diffthis('~')
        end,
        desc = 'Diff This ~',
      },
      { 'ih', ':<C-U>Gitsigns select_hunk<CR>', desc = 'GitSigns Select Hunk', mode = { 'o', 'x' } },
    },
    opts = {
      signs = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
        untracked = { text = '▎' },
      },
      signs_staged = {
        add = { text = '▎' },
        change = { text = '▎' },
        delete = { text = '' },
        topdelete = { text = '' },
        changedelete = { text = '▎' },
      },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
