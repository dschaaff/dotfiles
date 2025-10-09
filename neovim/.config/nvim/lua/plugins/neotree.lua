return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    enabled = not vim.g.vscode,
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
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
    config = function(_, opts)
      local function on_move(data)
        Snacks.rename.on_rename_file(data.source, data.destination)
      end

      local events = require('neo-tree.events')
      opts.event_handlers = opts.event_handlers or {}
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_move },
        { event = events.FILE_RENAMED, handler = on_move },
      })
      require('neo-tree').setup(opts)
      vim.api.nvim_create_autocmd('TermClose', {
        pattern = '*lazygit',
        callback = function()
          if package.loaded['neo-tree.sources.git_status'] then
            require('neo-tree.sources.git_status').refresh()
          end
        end,
      })
    end,
  },
  {
    'antosha417/nvim-lsp-file-operations',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-neo-tree/neo-tree.nvim', -- makes sure that this loads after Neo-tree.
    },
    config = function()
      require('lsp-file-operations').setup()
    end,
  },
}
