local on_lsp_attach = require "configs.lsp-mappings"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  server = {
    on_attach = function(client, bufnr)
      on_lsp_attach(client, bufnr)
    end,
    capabilities = capabilities,
    settings = {
      ["rust-analyzer"] = {
        cargo = {
          allFeatures = true,
        },
        checkOnSave = true,
      },
    },
  },
  dap = {},
  tools = {
    enable_clippy = true,
  },
}
