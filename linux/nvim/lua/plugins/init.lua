return {
  {
    "stevearc/conform.nvim",
    event = 'BufWritePre',
    opts = require "configs.conform",
  },

  -- Mason: Package manager for LSP servers, formatters, debuggers
  {
    "williamboman/mason.nvim",
    lazy = false,
    config = function()
      require("mason").setup()
    end,
  },

  -- LSP Configuration (without mason-lspconfig to avoid the bug)
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    dependencies = { "mason.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Rustaceanvim: Enhanced Rust support
  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
      require "configs.rustaceanvim"
    end,
  },

  -- nvim-cmp: Completion plugin
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "dmitmel/cmp-cmdline-history",
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

  -- Fugitive: Git wrapper
  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>", desc = "Git status" },
      { "<leader>gc", "<cmd>Git commit<cr>", desc = "Git commit" },
      { "<leader>gp", "<cmd>Git push<cr>", desc = "Git push" },
      { "<leader>gl", "<cmd>Git pull<cr>", desc = "Git pull" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>", desc = "Git diff" },
    },
  },
}
