-- LSP Keybindings
local map = vim.keymap.set

local on_lsp_attach = function(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  -- Go to definition
  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)

  -- Go to implementation
  map("n", "gi", vim.lsp.buf.implementation, opts)

  -- Find references
  map("n", "gr", vim.lsp.buf.references, opts)

  -- Hover
  map("n", "K", vim.lsp.buf.hover, opts)

  -- Signature help
  map("n", "<C-k>", vim.lsp.buf.signature_help, opts)

  -- Code actions
  map("n", "<leader>ca", vim.lsp.buf.code_action, opts)
  map("v", "<leader>ca", vim.lsp.buf.code_action, opts)

  -- Rename
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)

  -- Diagnostics
  map("n", "<leader>d", vim.diagnostic.open_float, opts)
  map("n", "[d", vim.diagnostic.goto_prev, opts)
  map("n", "]d", vim.diagnostic.goto_next, opts)
  map("n", "<leader>q", vim.diagnostic.setloclist, opts)

  -- Format
  if client.server_capabilities.documentFormattingProvider then
    map("n", "<leader>f", vim.lsp.buf.format, opts)
  end
end

return on_lsp_attach
