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

if os.getenv "SSH_CONNECTION" then
  vim.g.clipboard = {
    name = "OSC 52",
    copy = {
      ["+"] = require("vim.ui.clipboard.osc52").copy "+",
      ["*"] = require("vim.ui.clipboard.osc52").copy "*",
    },
    paste = {
      ["+"] = require("vim.ui.clipboard.osc52").paste "+",
      ["*"] = require("vim.ui.clipboard.osc52").paste "*",
    },
  }
end

vim.diagnostic.config {
  virtual_text = {
    prefix = "●",
    spacing = 4,
    source = "if_many",
  },
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = true,
  },
}
