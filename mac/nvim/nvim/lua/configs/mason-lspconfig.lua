-- Mason LSP Config: Automatically configure LSP servers installed via Mason
-- With Neovim 0.11+, mason-lspconfig integrates with vim.lsp.config
require("mason-lspconfig").setup {
  automatic_installation = true,
  handlers = {
    -- Default handler for servers not explicitly configured
    function(server_name)
      require("mason-lspconfig").default_setup(server_name)
    end,
  },
}
