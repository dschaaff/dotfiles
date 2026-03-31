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
