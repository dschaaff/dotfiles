require('ibl').setup({
  indent = {
    char = '│',
    tab_char = '│',
  },
  scope = { show_start = false, show_end = false },
  exclude = {
    filetypes = {
      'Trouble',
      'alpha',
      'dashboard',
      'help',
      'mason',
      'neo-tree',
      'notify',
      'snacks_dashboard',
      'snacks_notif',
      'snacks_terminal',
      'snacks_win',
      'toggleterm',
      'trouble',
    },
  },
})
