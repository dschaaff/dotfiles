return {
  { -- Collection of various small independent plugins/modules
    'echasnovski/mini.nvim',
    version = '*',
    config = function()
      -- Better Around/Inside textobjects
      --
      -- Examples:
      --  - va)  - [V]isually select [A]round [)]paren
      --  - yinq - [Y]ank [I]nside [N]ext [Q]uote
      --  - ci'  - [C]hange [I]nside [']quote
      require('mini.ai').setup({ n_lines = 500 })

      require('mini.pairs').setup()
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

      -- Simple and easy statusline.
      --  You could remove this setup call if you don't like it,
      --  and try some other statusline plugin
      require('mini.icons').setup()
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
      --  Check out: https://github.com/echasnovski/mini.nvim
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
