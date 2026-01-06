local on_lsp_attach = require "configs.lsp-mappings"
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure diagnostics (error/warning display)
vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
}

-- Global LSP options
local on_attach = function(client, bufnr)
  -- Setup keybindings
  on_lsp_attach(client, bufnr)

  -- Disable inlay hints due to rust-analyzer bug with invalid column positions
  -- Re-enable after rust-analyzer fix
  -- if client.server_capabilities.inlayHintProvider then
  --   vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  -- end
end

-- Rust Analyzer Configuration using vim.lsp.config (Neovim 0.11+)
vim.lsp.config("rust_analyzer", {
  cmd = { "rust-analyzer" },
  filetypes = { "rust" },
  root_markers = { "Cargo.toml", "rustfmt.toml", "rust-project.json" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = {
        allFeatures = true,
      },
      checkOnSave = true,
    },
  },
})

-- HTML LSP
vim.lsp.config("html", {
  filetypes = { "html" },
  on_attach = on_attach,
  capabilities = capabilities,
})

-- CSS LSP
vim.lsp.config("cssls", {
  filetypes = { "css", "scss", "less" },
  on_attach = on_attach,
  capabilities = capabilities,
})

-- JSON LSP
vim.lsp.config("jsonls", {
  filetypes = { "json", "jsonc" },
  on_attach = on_attach,
  capabilities = capabilities,
})

-- TypeScript/JavaScript LSP
vim.lsp.config("ts_ls", {
  filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    typescript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
    javascript = {
      inlayHints = {
        includeInlayParameterNameHints = "all",
        includeInlayParameterNameHintsWhenArgumentMatchesName = false,
        includeInlayFunctionParameterTypeHints = true,
        includeInlayVariableTypeHints = true,
        includeInlayPropertyDeclarationTypeHints = true,
        includeInlayFunctionLikeReturnTypeHints = true,
        includeInlayEnumMemberValueHints = true,
      },
    },
  },
})

-- Tailwind CSS LSP
vim.lsp.config("tailwindcss", {
  filetypes = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    tailwindCSS = {
      experimental = {
        classRegex = {
          { "cva\\(([^)]*)\\)", "[\"'`]([^\"'`]*).*?[\"'`]" },
          { "cx\\(([^)]*)\\)", "(?:'|\"|`)([^']*)(?:'|\"|`)" },
        },
      },
    },
  },
})

-- ESLint LSP
vim.lsp.config("eslint", {
  filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    workingDirectory = { mode = "auto" },
  },
})

-- Enable all configured servers
vim.lsp.enable { "rust_analyzer", "html", "cssls", "jsonls", "ts_ls", "tailwindcss", "eslint" }

