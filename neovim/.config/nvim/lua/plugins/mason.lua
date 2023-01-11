local M = {
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim"
}

function M.config()
  require("mason").setup()
  M.check()
  require("mason-lspconfig").setup({
    automatic_installation = true,
  })
end

return M
