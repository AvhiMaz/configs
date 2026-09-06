return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = function()
      return require "configs.snacks"
    end,
  },

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
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "gruvbox",
        component_separators = "|",
        section_separators = "",
      },
      sections = {
        lualine_x = {
          {
            function() return "󰚩 Copilot" end,
            color = function()
              local ok, client = pcall(function() return require("copilot.client").get() end)
              if ok and client then
                return { fg = "#fabd2f" }
              end
              return { fg = "#665c54" }
            end,
          },
          "encoding",
          "fileformat",
          "filetype",
        },
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
    cmd = { "Mason", "MasonInstall", "MasonUpdate", "MasonUninstall" },
    opts = {},
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy",
    dependencies = { "mason.nvim" },
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
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    dependencies = { "mason.nvim" },
    config = function()
      require "configs.lspconfig"
    end,
  },

  {
    "mrcjkb/rustaceanvim",
    version = "^9",
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
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {},
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", "<cmd>Telescope find_files<cr>" },
      {
        "<leader>fF",
        function()
          require("configs.telescope-dir").pick_dir()
        end,
      },
      {
        "<leader>fA",
        function()
          require("configs.telescope-dir").find_files_anywhere()
        end,
      },
      { "<leader>fw", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fg", "<cmd>Telescope live_grep<cr>" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>" },
      { "<leader>dt", "<cmd>Telescope diagnostics<cr>" },
      { "<leader>fy", "<cmd>Telescope neoclip<cr>" },
    },
  },

  {
    "mbbill/undotree",
    cmd = "UndotreeToggle",
    keys = {
      { "<leader>u", "<cmd>UndotreeToggle<cr>" },
    },
  },

  {
    "AckslD/nvim-neoclip.lua",
    dependencies = { "nvim-telescope/telescope.nvim" },
    event = "VeryLazy",
    config = function()
      require("neoclip").setup()
      require("telescope").load_extension "neoclip"
    end,
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
    dependencies = { "nvim-lua/plenary.nvim", "m00qek/baleia.nvim" },
    cmd = { "Compile", "Recompile" },
    keys = {
      { "<leader>cc", function() require("configs.compile-mode").compile() end },
      { "<leader>ch", function() require("configs.compile-mode").history() end },
      { "<leader>cr", "<cmd>Recompile<cr>" },
    },
    config = function()
      require("configs.compile-mode").setup()
    end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>a", function() require("harpoon"):list():add() end },
      { "<C-e>", function() local h = require "harpoon" h.ui:toggle_quick_menu(h:list()) end },
      { "<leader>1", function() require("harpoon"):list():select(1) end },
      { "<leader>2", function() require("harpoon"):list():select(2) end },
      { "<leader>3", function() require("harpoon"):list():select(3) end },
      { "<leader>4", function() require("harpoon"):list():select(4) end },
      { "<leader>hc", function() require("harpoon"):list():clear() end },
    },
    config = function()
      require("harpoon"):setup()
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    keys = {
      { "<leader>gg", "<cmd>LazyGit<cr>" },
    },
  },

  {
    "zbirenbaum/copilot.lua",
    event = "InsertEnter",
    config = function()
      require "configs.copilot"
    end,
  },

  {
    "gelguy/wilder.nvim",
    event = "CmdlineEnter",
    dependencies = { "romgrk/fzy-lua-native" },
    config = function()
      local wilder = require "wilder"
      wilder.setup { modes = { ":", "/", "?" } }
      wilder.set_option("use_python_remote_plugin", 0)
      wilder.set_option("pipeline", {
        wilder.branch(
          wilder.cmdline_pipeline {
            fuzzy = 1,
            fuzzy_filter = wilder.lua_fzy_filter(),
          },
          wilder.search_pipeline()
        ),
      })
      wilder.set_option("renderer", wilder.wildmenu_renderer {
        highlighter = wilder.basic_highlighter(),
      })
    end,
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
