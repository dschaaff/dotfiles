return {
  'NMAC427/guess-indent.nvim',
  config = function()
    require('guess-indent').setup({
      filetype_exclude = { -- A list of filetypes for which the auto command gets disabled
        'netrw',
        'tutor',
        'lazygit',
        'neo-tree',
        'neo-tree-popup',
        'notify',
      },
      buftype_exclude = { -- A list of buffer types for which the auto command gets disabled
        'help',
        'nofile',
        'terminal',
        'prompt',
      },
    })
  end,
}
