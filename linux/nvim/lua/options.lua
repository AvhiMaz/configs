require "nvchad.options"

local o = vim.o
local g = vim.g

-- Better development experience
o.number = true -- absolute line numbers
o.relativenumber = true -- relative line numbers
o.cursorlineopt = "both" -- enable cursorline
o.signcolumn = "yes:2" -- always show sign column with width 2
o.pumheight = 15 -- height of popup menu for autocomplete
o.completeopt = "menuone,noselect" -- completion options

-- Indentation
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.expandtab = true
o.autoindent = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase = true
o.hlsearch = false

-- Better splits
o.splitbelow = true
o.splitright = true

-- Folding
o.foldenable = true
o.foldlevel = 99

-- Timeout for key sequences
o.timeoutlen = 500
o.updatetime = 200

-- Undofile for persistent undo
o.undofile = true

-- OSC 52 clipboard (works over SSH)
if os.getenv("SSH_CONNECTION") then
  g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
      ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
      ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
    },
  }
end
