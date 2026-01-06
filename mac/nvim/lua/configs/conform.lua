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

  format_on_save = function(bufnr)
    local ft = vim.bo[bufnr].filetype
    if ft == "rust" or ft == "typescript" or ft == "typescriptreact" or ft == "javascript" or ft == "javascriptreact" then
      return {
        timeout_ms = 2000,
        lsp_fallback = true,
      }
    end
  end,
}

return options
