local map = vim.keymap.set

local on_lsp_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("n", "<C-k>", vim.lsp.buf.signature_help, opts)
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("v", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>d", vim.diagnostic.open_float, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>q", function()
    vim.diagnostic.setqflist({ open = true })
  end, opts)
  map("n", "<leader>dd", "<cmd>Telescope diagnostics<cr>", opts)

  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>f", vim.lsp.buf.format, opts)
  end
end

return on_lsp_attach
