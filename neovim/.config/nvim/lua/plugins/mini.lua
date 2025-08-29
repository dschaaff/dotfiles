return {
  { -- Collection of various small independent plugins/modules
    'nvim-mini/mini.nvim',
    version = '*',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      -- https://github.com/nvim-mini/mini.nvim/blob/main/readmes/mini-tabline.md
      require('mini.tabline').setup()

      require('mini.pairs').setup()

      require('mini.bracketed').setup()

      require('mini.bufremove').setup()
      -- Add/delete/replace surroundings (brackets, quotes, etc.)
      --
      -- - gsaiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      -- - gsd'   - [S]urround [D]elete [']quotes
      -- - gsr)'  - [S]urround [R]eplace [)] [']
      local surround_mappings = {
        add = 'gsa', -- Add surrounding in Normal and Visual modes
        delete = 'gsd', -- Delete surrounding
        find = 'gsf', -- Find surrounding (to the right)
        find_left = 'gsF', -- Find surrounding (to the left)
        highlight = 'gsh', -- Highlight surrounding
        replace = 'gsr', -- Replace surrounding
        update_n_lines = 'gsn', -- Update `n_lines`
      }

      require('mini.surround').setup({
        mappings = surround_mappings,
      })

      -- Register mini.surround keymaps with which-key
      local wk = require('which-key')
      local which_key_mappings = {}
      local descriptions = {
        add = 'Add surrounding',
        delete = 'Delete surrounding',
        find = 'Find right surrounding',
        find_left = 'Find left surrounding',
        highlight = 'Highlight surrounding',
        replace = 'Replace surrounding',
        update_n_lines = 'Update `MiniSurround.config.n_lines`',
      }

      for action, keymap in pairs(surround_mappings) do
        table.insert(which_key_mappings, { keymap, desc = descriptions[action] })
      end

      wk.add(which_key_mappings)

      -- Buffer navigation using mini.bracketed
      wk.add({
        {
          '<S-h>',
          function()
            require('mini.bracketed').buffer('backward')
          end,
          desc = 'Prev Buffer',
        },
        {
          '<S-l>',
          function()
            require('mini.bracketed').buffer('forward')
          end,
          desc = 'Next Buffer',
        },
      })

      -- Buffer delete keymaps
      wk.add({
        {
          '<leader>bd',
          function()
            require('mini.bufremove').delete()
          end,
          desc = 'Delete Buffer',
        },
        { '<leader>bD', '<cmd>bd<cr>', desc = 'Delete Buffer and Window' },
        {
          '<leader>bo',
          function()
            local current_buf = vim.api.nvim_get_current_buf()
            local buffers = vim.api.nvim_list_bufs()
            for _, buf in ipairs(buffers) do
              if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
                require('mini.bufremove').delete(buf)
              end
            end
          end,
          desc = 'Delete Other Buffers',
        },
      })
      -- split join: use gS to split or join lines like [a, b, c, d]
      require('mini.splitjoin').setup()

      require('mini.icons').setup()
      MiniIcons.mock_nvim_web_devicons()

      local statusline = require('mini.statusline')
      -- set use_icons to true if you have a Nerd Font
      statusline.setup({ use_icons = true })

      -- You can configure sections in the statusline by overriding their
      -- default behavior. For example, here we set the section for
      -- cursor location to LINE:COLUMN
      ---@diagnostic disable-next-line: duplicate-set-field
      statusline.section_location = function()
        return '%2l:%-2v'
      end

      -- ... and there is more!
      --  Check out: https://github.com/nvim-mini/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
