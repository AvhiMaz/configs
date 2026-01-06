-- Rustaceanvim: Enhanced Rust development experience
-- Note: Rustaceanvim uses its own server config, which wraps vim.lsp.config internally
local on_lsp_attach = require "configs.lsp-mappings"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

return {
  -- Server configuration
  server = {
    on_attach = function(client, bufnr)
      -- Setup keybindings
      on_lsp_attach(client, bufnr)

      -- Disable inlay hints due to rust-analyzer bug
      -- vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
    -- Disable inlay hints in settings too
    inlayHints = {
      enabled = false,
    },
  },

  -- DAP Configuration (debugging)
  dap = {},

  -- Tools configuration
  tools = {
    enable_clippy = true,
  },
}
