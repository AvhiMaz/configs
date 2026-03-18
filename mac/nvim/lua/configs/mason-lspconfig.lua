require("mason-lspconfig").setup {
  automatic_installation = true,
  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup {}
    end,
    rust_analyzer = function() end,
  },
}
