require('fidget').setup({})
require('mason').setup({})
vim.keymap.set('n', '<leader>cm', '<cmd>Mason<cr>', { desc = 'Mason' })

-- LSP keymaps on attach
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>cl', '<cmd>LspInfo<cr>', 'Lsp Info')
    map('gd', vim.lsp.buf.definition, 'Goto Definition')
    map('gr', vim.lsp.buf.references, 'References')
    map('gI', vim.lsp.buf.implementation, 'Goto Implementation')
    map('gy', vim.lsp.buf.type_definition, 'Goto T[y]pe Definition')
    map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
    map('K', vim.lsp.buf.hover, 'Hover')
    map('gK', vim.lsp.buf.signature_help, 'Signature Help')
    map('<c-k>', vim.lsp.buf.signature_help, 'Signature Help', 'i')
    map('<leader>ca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'v' })
    map('<leader>cc', vim.lsp.codelens.run, 'Run Codelens', { 'n', 'v' })
    map('<leader>cC', vim.lsp.codelens.refresh, 'Refresh & Display Codelens')

    map('<leader>cR', function()
      local old_name = vim.api.nvim_buf_get_name(0)
      local new_name = vim.fn.input('New file name: ', old_name)
      if new_name ~= '' and new_name ~= old_name then
        vim.lsp.util.rename(old_name, new_name)
      end
    end, 'Rename File')

    map('<leader>cr', vim.lsp.buf.rename, 'Rename')

    map('<leader>cA', function()
      vim.lsp.buf.code_action({ context = { only = { 'source' } } })
    end, 'Source Action')

    map(']]', function()
      vim.diagnostic.goto_next({ wrap = false })
    end, 'Next Reference')

    map('[[', function()
      vim.diagnostic.goto_prev({ wrap = false })
    end, 'Prev Reference')

    map('<a-n>', function()
      vim.diagnostic.goto_next({ wrap = false })
    end, 'Next Reference')

    map('<a-p>', function()
      vim.diagnostic.goto_prev({ wrap = false })
    end, 'Prev Reference')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if
      client
      and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf)
    then
      local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })

      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })

      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
        end,
      })
    end

    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
      end, '[T]oggle Inlay [H]ints')
    end
  end,
})

-- Diagnostic config
vim.diagnostic.config({
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  underline = { severity = vim.diagnostic.severity.ERROR },
  signs = vim.g.have_nerd_font and {
    text = {
      [vim.diagnostic.severity.ERROR] = '󰅚 ',
      [vim.diagnostic.severity.WARN] = '󰀪 ',
      [vim.diagnostic.severity.INFO] = '󰋽 ',
      [vim.diagnostic.severity.HINT] = '󰌶 ',
    },
  } or {},
  virtual_text = {
    source = 'if_many',
    spacing = 2,
    format = function(diagnostic)
      local diagnostic_message = {
        [vim.diagnostic.severity.ERROR] = diagnostic.message,
        [vim.diagnostic.severity.WARN] = diagnostic.message,
        [vim.diagnostic.severity.INFO] = diagnostic.message,
        [vim.diagnostic.severity.HINT] = diagnostic.message,
      }
      return diagnostic_message[diagnostic.severity]
    end,
  },
})

-- LSP capabilities from blink.cmp
local capabilities = require('blink.cmp').get_lsp_capabilities()

-- Server configurations
local servers = {
  ansiblels = {},
  bashls = {},
  dockerls = {},
  helm_ls = {},
  intelephense = {},
  jsonls = {
    on_new_config = function(new_config)
      new_config.settings.json.schemas = new_config.settings.json.schemas or {}
      vim.list_extend(new_config.settings.json.schemas, require('schemastore').json.schemas())
    end,
    settings = {
      json = {
        format = { enable = true },
        validate = { enable = true },
      },
    },
  },
  ['jsonnet-language-server'] = {},
  gopls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = { callSnippet = 'Replace' },
        diagnostics = { globals = { 'vim' } },
      },
    },
  },
  ['markdownlint-cli2'] = {},
  ['markdown-toc'] = {},
  pyright = {},
  basedpyright = {},
  ruff = {
    cmd_env = { RUFF_TRACE = 'messages' },
    init_options = {
      settings = { logLevel = 'error' },
    },
  },
  vale = {},
  markdownlint = {},
  shellcheck = {},
  marksman = {},
  tofu_ls = {},
  tflint = {},
  yamlls = {
    settings = {
      redhat = { telemetry = { enabled = false } },
      yaml = {
        keyOrdering = false,
        format = { enable = true },
        validate = true,
        customTags = { '!reference sequence' },
        schemas = require('schemastore').yaml.schemas(),
        schemaStore = {
          enable = false,
          url = '',
        },
      },
    },
  },
}

local formatters = {
  shfmt = {},
  stylua = {},
  jsonnetfmt = {},
}

-- Install LSPs and tools via mason
local ensure_installed = vim.list_extend(vim.tbl_keys(servers or {}), vim.tbl_keys(formatters or {}))
require('mason-tool-installer').setup({ ensure_installed = ensure_installed })

require('mason-lspconfig').setup({
  ensure_installed = {},
  automatic_enable = true,
})

for server_name, server_config in pairs(servers) do
  local config = vim.tbl_deep_extend('force', {
    capabilities = capabilities,
  }, server_config)
  vim.lsp.config(server_name, config)
end
