local map = vim.keymap.set

local on_lsp_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)

  map("n", "<leader>lf", function()
    require("conform").format({ bufnr = bufnr, lsp_fallback = true })
  end, opts)
end

return on_lsp_attach
