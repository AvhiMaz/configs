local on_lsp_attach = require "configs.lsp-mappings"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  server = {
    on_attach = function(client, bufnr)
      on_lsp_attach(client, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
        inlayHints = {
          typeHints = { enable = true },
          chainingHints = { enable = true },
          parameterHints = { enable = true },
          closureReturnTypeHints = { enable = "always" },
          lifetimeElisionHints = { enable = "always", useParameterNames = true },
        },
      },
    },
  },
  dap = {},
  tools = {
    enable_clippy = true,
  },
}
