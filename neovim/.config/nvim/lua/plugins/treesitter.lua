return {
  { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    build = ':TSUpdate',
    -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
    config = function()
      -- Enable treesitter highlighting for every filetype
      vim.api.nvim_create_autocmd('FileType', {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })

      -- Install parsers (no-op if already present)
      local parsers = {
        'bash',
        'c',
        'diff',
        'git_config',
        'gitcommit',
        'git_rebase',
        'gitignore',
        'gitattributes',
        'go',
        'gomod',
        'hcl',
        'helm',
        'html',
        'javascript',
        'json',
        'json5',
        'jsonnet',
        'lua',
        'luadoc',
        'luap',
        'markdown',
        'markdown_inline',
        'ninja',
        'php',
        'python',
        'query',
        'regex',
        'rst',
        'terraform',
        'tsx',
        'typescript',
        'vim',
        'yaml',
      }
      pcall(require('nvim-treesitter').install, parsers)
    end,
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
