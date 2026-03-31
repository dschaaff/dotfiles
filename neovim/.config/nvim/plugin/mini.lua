-- Inline dependency: which-key must be set up before wk.add() calls
require('which-key').setup({})
vim.keymap.set('n', '<leader>?', function()
  require('which-key').show({ global = false })
end, { desc = 'Buffer Local Keymaps (which-key)' })

-- Better Around/Inside textobjects
require('mini.ai').setup({ n_lines = 500 })

require('mini.tabline').setup()

require('mini.pairs').setup()

require('mini.bracketed').setup()

require('mini.bufremove').setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
local surround_mappings = {
  add = 'gsa',
  delete = 'gsd',
  find = 'gsf',
  find_left = 'gsF',
  highlight = 'gsh',
  replace = 'gsr',
  update_n_lines = 'gsn',
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

-- split join: use gS to split or join lines
require('mini.splitjoin').setup()

require('mini.icons').setup()
MiniIcons.mock_nvim_web_devicons()

local statusline = require('mini.statusline')
statusline.setup({ use_icons = true })

---@diagnostic disable-next-line: duplicate-set-field
statusline.section_location = function()
  return '%2l:%-2v'
end
