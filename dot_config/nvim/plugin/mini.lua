-- Better Around/Inside textobjects
require('mini.ai').setup({ n_lines = 500 })

require('mini.tabline').setup()

require('mini.pairs').setup()

require('mini.bracketed').setup()

require('mini.bufremove').setup()

-- Add/delete/replace surroundings (brackets, quotes, etc.)
require('mini.surround').setup({
  mappings = {
    add = 'gsa',
    delete = 'gsd',
    find = 'gsf',
    find_left = 'gsF',
    highlight = 'gsh',
    replace = 'gsr',
    update_n_lines = 'gsn',
  },
})

-- Buffer navigation using mini.bracketed
vim.keymap.set('n', '<S-h>', function()
  require('mini.bracketed').buffer('backward')
end, { desc = 'Prev Buffer' })

vim.keymap.set('n', '<S-l>', function()
  require('mini.bracketed').buffer('forward')
end, { desc = 'Next Buffer' })

-- Buffer delete keymaps
vim.keymap.set('n', '<leader>bd', function()
  require('mini.bufremove').delete()
end, { desc = 'Delete Buffer' })

vim.keymap.set('n', '<leader>bD', '<cmd>bd<cr>', { desc = 'Delete Buffer and Window' })

vim.keymap.set('n', '<leader>bo', function()
  local current_buf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= current_buf and vim.api.nvim_buf_is_loaded(buf) and vim.bo[buf].buflisted then
      require('mini.bufremove').delete(buf)
    end
  end
end, { desc = 'Delete Other Buffers' })

require('mini.cmdline').setup()

require('mini.files').setup()

vim.keymap.set('n', '<leader>mf', function()
  require('mini.files').open(vim.api.nvim_buf_get_name(0))
end, { desc = 'Mini Files' })

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

-- mini.clue: keymap hint popup (replaces which-key)
local miniclue = require('mini.clue')
miniclue.setup({
  triggers = {
    { mode = { 'n', 'x' }, keys = '<Leader>' },
    { mode = { 'n', 'x' }, keys = 'g' },
    { mode = { 'n', 'x' }, keys = "'" },
    { mode = { 'n', 'x' }, keys = '`' },
    { mode = { 'n', 'x' }, keys = '"' },
    { mode = { 'n', 'x' }, keys = 'z' },
    { mode = { 'i', 'c' }, keys = '<C-r>' },
    { mode = 'i', keys = '<C-x>' },
    { mode = 'n', keys = '<C-w>' },
    { mode = 'n', keys = ']' },
    { mode = 'n', keys = '[' },
  },
  clues = {
    miniclue.gen_clues.builtin_completion(),
    miniclue.gen_clues.g(),
    miniclue.gen_clues.marks(),
    miniclue.gen_clues.registers(),
    miniclue.gen_clues.square_brackets(),
    miniclue.gen_clues.windows(),
    miniclue.gen_clues.z(),
    -- Group labels
    { mode = { 'n', 'x' }, keys = '<Leader>a', desc = '+ai' },
    { mode = { 'n', 'x' }, keys = '<Leader>ac', desc = '+sidekick' },
    { mode = 'n', keys = '<Leader>b', desc = '+buffer' },
    { mode = { 'n', 'x' }, keys = '<Leader>c', desc = '+code' },
    { mode = 'n', keys = '<Leader>f', desc = '+find' },
    { mode = { 'n', 'x' }, keys = '<Leader>g', desc = '+git' },
    { mode = { 'n', 'x' }, keys = '<Leader>gh', desc = '+hunks' },
    { mode = 'n', keys = '<Leader>s', desc = '+search' },
    { mode = 'n', keys = '<Leader>t', desc = '+toggle' },
    { mode = 'n', keys = '<Leader>u', desc = '+ui' },
  },
  window = {
    delay = 300,
    config = { width = 'auto' },
  },
})
