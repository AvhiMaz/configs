return {
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup {
        overrides = {
          Comment = { italic = true, fg = "#928374" },
        },
      }
      vim.o.background = "dark"
      vim.cmd.colorscheme "gruvbox"
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = "|",
        section_separators = "",
      },
    },
  },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    opts = require "configs.conform",
  },

  {
    "williamboman/mason.nvim",
    lazy = false,
    cmd = { "Mason", "MasonInstall", "MasonUninstall", "MasonUninstallAll", "MasonLog" },
    opts = {
      ensure_installed = {
        "typescript-language-server",
        "tailwindcss-language-server",
        "eslint-lsp",
        "html-lsp",
        "css-lsp",
        "json-lsp",
        "gopls",
        "clangd",
        "prettier",
        "stylua",
      },
    },
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = "mason.nvim",
    cmd = { "LspInstall", "LspUninstall" },
    config = function()
      require "configs.mason-lspconfig"
    end,
  },

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

  {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      vim.g.rustaceanvim = require "configs.rustaceanvim"
    end,
  },

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

  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "vim", "lua", "vimdoc",
        "html", "css",
        "rust", "toml",
        "json", "javascript", "typescript", "tsx",
        "markdown", "markdown_inline",
        "c", "cpp",
      },
      highlight = { enable = true },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>" },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
      "refractalize/oil-git-status.nvim",
    },
    lazy = false,
    keys = {
      { "<leader>e", "<cmd>Oil<cr>" },
    },
    config = function()
      require("oil").setup {
        default_file_explorer = true,
        view_options = { show_hidden = true },
        win_options = { signcolumn = "yes:2" },
      }
      require("oil-git-status").setup {}
    end,
  },

  {
    "ej-shafran/compile-mode.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "Compile", "Recompile" },
    keys = {
      { "<leader>cc", "<cmd>Compile<cr>" },
      { "<leader>cr", "<cmd>Recompile<cr>" },
    },
    config = function()
      vim.g.compile_mode = { recompile_no_fail = true }
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "G", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
    keys = {
      { "<leader>gs", "<cmd>Git<cr>" },
      { "<leader>gc", "<cmd>Git commit<cr>" },
      { "<leader>gp", "<cmd>Git push<cr>" },
      { "<leader>gl", "<cmd>Git pull<cr>" },
      { "<leader>gd", "<cmd>Gdiffsplit<cr>" },
    },
  },
}
