return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },

  -- Mason: Package manager for LSP servers, formatters, debuggers
  {
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {
        -- LSP servers
        "rust-analyzer",
        "typescript-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        -- Formatters
        "prettier",
        "stylua",
      },
    },
  },

  -- Mason LSP Config: Bridges mason and lspconfig
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      require "configs.mason-lspconfig"
    end,
  },

  -- LSP Configuration
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
    },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Rustaceanvim: Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      require "configs.rustaceanvim"
    end,
  },

  -- nvim-cmp: Completion plugin
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      require "configs.cmp"
    end,
  },

  -- Treesitter for better syntax highlighting
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "rust",
        "toml",
        "json",
        "javascript",
        "typescript",
        "tsx",
        "markdown",
        "markdown_inline",
      },
      highlight = {
        enable = true,
      },
    },
  },
}
