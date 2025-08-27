return {
  'nvim-neo-tree/neo-tree.nvim',
  enabled = not vim.g.vscode,
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', ':Neotree toggle<CR>', desc = 'NeoTree [E]xplorer Toggle', silent = true },
  },
  opts = {
    open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
