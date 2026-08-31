-- Portable single-file Neovim config.
-- Install:  wget -O ~/.config/nvim/init.lua <raw-url>
-- Requires: nvim 0.11+, git. LSP servers are used only if already on PATH.

vim.g.mapleader = " "

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system {
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------------------------- options

local o = vim.o

o.number = true
o.relativenumber = true
o.cursorlineopt = "both"
o.signcolumn = "yes:2"
o.pumheight = 15
o.completeopt = "menuone,noselect"

o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true

o.ignorecase = true
o.smartcase = true
o.hlsearch = false

o.splitbelow = true
o.splitright = true

o.foldenable = true
o.foldlevel = 99

o.timeoutlen = 500
o.updatetime = 200

o.undofile = true
o.autoread = true

o.clipboard = "unnamedplus"
o.guicursor = "a:block"

if os.getenv "SSH_CONNECTION" then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = function() return vim.split(vim.fn.getreg "", "\n") end,
      ["*"] = function() return vim.split(vim.fn.getreg "", "\n") end,
    },
  }
end

vim.diagnostic.config {
  virtual_text = { prefix = "●", spacing = 4, source = "if_many" },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = { border = "rounded", source = true },
}

-------------------------------------------------------------------- autocmds

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function() vim.cmd "checktime" end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

-------------------------------------------------------------------- mappings

local map = vim.keymap.set

map("n", ";", ":")
map("i", "jk", "<ESC>")

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end)
map("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end)
map("n", "<leader>df", vim.diagnostic.open_float)
map("n", "<leader>dl", vim.diagnostic.setloclist)
map("n", "<leader>dq", vim.diagnostic.setqflist)

for _, k in ipairs { "<Up>", "<Down>", "<Left>", "<Right>" } do
  map({ "n", "i", "v" }, k, "<Nop>")
end

---------------------------------------------------------------- lsp on_attach

local function on_lsp_attach(_, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }

  map("n", "gd", vim.lsp.buf.definition, opts)
  map("n", "gD", vim.lsp.buf.declaration, opts)
  map("n", "gi", vim.lsp.buf.implementation, opts)
  map("n", "gr", vim.lsp.buf.references, opts)
  map("n", "K", vim.lsp.buf.hover, opts)
  map("i", "<C-k>", vim.lsp.buf.signature_help, opts)
  map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)
  map("n", "<leader>rn", vim.lsp.buf.rename, opts)
  map("n", "<leader>lf", function() vim.lsp.buf.format { bufnr = bufnr } end, opts)
end

-- Enable a server only when its binary already exists on this machine.
local servers = {
  rust_analyzer = "rust-analyzer",
  clangd = "clangd",
  gopls = "gopls",
  lua_ls = "lua-language-server",
  pyright = "pyright-langserver",
  ts_ls = "typescript-language-server",
  jsonls = "vscode-json-language-server",
  html = "vscode-html-language-server",
  cssls = "vscode-css-language-server",
}

--------------------------------------------------------------------- plugins

require("lazy").setup({
  {
    "ellisonleao/gruvbox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("gruvbox").setup {
        overrides = { Comment = { italic = true, fg = "#928374" } },
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
      { "<leader>dt", "<cmd>Telescope diagnostics<cr>" },
    },
  },

  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = false,
    keys = { { "<leader>e", "<cmd>Oil<cr>" } },
    opts = {
      default_file_explorer = true,
      view_options = { show_hidden = true },
      win_options = { signcolumn = "yes:2" },
    },
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
    config = function() require("harpoon"):setup() end,
  },

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {},
  },

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
      local cmp = require "cmp"
      local luasnip = require "luasnip"

      cmp.setup {
        snippet = {
          expand = function(args) luasnip.lsp_expand(args.body) end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered { max_width = 60, max_height = 15 },
        },
        mapping = cmp.mapping.preset.insert {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.abort(),
          ["<CR>"] = cmp.mapping.confirm { select = true },
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        },
        sources = cmp.config.sources {
          { name = "nvim_lsp", priority = 100 },
          { name = "luasnip", priority = 75 },
          { name = "buffer", priority = 50 },
          { name = "path", priority = 40 },
        },
        performance = { max_view_entries = 200 },
      }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      if vim.fn.has "nvim-0.11" == 0 then
        vim.notify("LSP setup skipped: needs nvim 0.11+", vim.log.levels.WARN)
        return
      end

      local ok, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      local capabilities = ok and cmp_lsp.default_capabilities() or nil

      local enabled = {}
      for server, binary in pairs(servers) do
        if vim.fn.executable(binary) == 1 then
          vim.lsp.config(server, {
            on_attach = on_lsp_attach,
            capabilities = capabilities,
          })
          enabled[#enabled + 1] = server
        end
      end

      if #enabled > 0 then
        vim.lsp.enable(enabled)
      end
    end,
  },
}, {
  defaults = { lazy = true },
  install = { colorscheme = { "gruvbox" } },
  performance = {
    rtp = {
      disabled_plugins = {
        "2html_plugin", "tohtml", "getscript", "getscriptPlugin", "gzip",
        "logipat", "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers",
        "matchit", "tar", "tarPlugin", "rrhelper", "spellfile_plugin",
        "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
        "syntax", "synmenu", "optwin", "compiler", "bugreport",
      },
    },
  },
})
