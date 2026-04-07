local on_lsp_attach = require "configs.lsp-mappings"
local capabilities = vim.tbl_deep_extend("force", require("cmp_nvim_lsp").default_capabilities(), {
  offsetEncoding = { "utf-8" },
})

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
        check = { command = "clippy" },
        inlayHints = {
          bindingModeHints = { enable = true },
          chainingHints = { enable = true },
          closingBraceHints = { enable = true },
          parameterHints = { enable = true },
          typeHints = { enable = true },
        },
      },
    },
  },
  dap = {},
  tools = {
    enable_clippy = true,
  },
}
