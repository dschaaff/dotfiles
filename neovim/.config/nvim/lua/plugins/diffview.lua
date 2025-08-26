return {
  'MagicDuck/grug-far.nvim',
  opts = {
    headerMaxWidth = 80,
    engines = {
      ripgrep = {
        extraArgs = '--hidden --glob !.git/ --glob !.terraform --glob !node_modules --glob !.DS_Store',
      },
    },
  },
  cmd = 'GrugFar',
  keys = {
    {
      '<leader>sr',
      function()
        local grug = require('grug-far')
        local ext = vim.bo.buftype == '' and vim.fn.expand('%:e')
        grug.open({
          transient = true,
          prefills = {
            filesFilter = ext and ext ~= '' and '*.' .. ext or nil,
          },
        })
      end,
      mode = { 'n', 'v' },
      desc = 'Search and Replace',
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
