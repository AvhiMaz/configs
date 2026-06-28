local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    javascriptreact = { "prettier" },
    typescript = { "prettier" },
    typescriptreact = { "prettier" },
    css = { "prettier" },
    scss = { "prettier" },
    html = { "prettier" },
    json = { "prettier" },
    jsonc = { "prettier" },
    markdown = { "prettier" },
  },

  format_on_save = {
    timeout_ms = 2000,
    lsp_fallback = true,
  },
}

return options
