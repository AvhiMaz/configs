vim.g.base46_cache = vim.fn.stdpath "data" .. "/base46/"
vim.g.mapleader = " "

vim.api.nvim_set_keymap(
  "n",
  "<leader>fp",
  [[:%!npx prettier --stdin-filepath %:p<CR>]],
  { noremap = true, silent = true }
)

local esc = vim.api.nvim_replace_termcodes("<Esc>", true, false, true)

local keys = "yoconsole.log()" .. esc .. 'i"' .. esc .. "hpla, " .. esc .. "p" .. esc

vim.fn.setreg("l", vim.api.nvim_replace_termcodes(keys, true, false, true))

vim.api.nvim_create_user_command("WipeReg", function()
  local regs = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789/-="*+'
  for i = 1, #regs do
    local reg = regs:sub(i, i)
    vim.fn.setreg(reg, {})
  end
end, {})

-- bootstrap lazy and all plugins
local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  vim.fn.system { "git", "clone", "--filter=blob:none", repo, "--branch=stable", lazypath }
end

vim.opt.rtp:prepend(lazypath)

vim.wo.relativenumber = true

local lazy_config = require "configs.lazy"

-- load plugins
require("lazy").setup({
  {
    "NvChad/NvChad",
    lazy = false,
    branch = "v2.5",
    import = "nvchad.plugins",
  },

  { import = "plugins" },
}, lazy_config)

-- load theme
dofile(vim.g.base46_cache .. "defaults")
dofile(vim.g.base46_cache .. "statusline")

require "options"
require "nvchad.autocmds"

vim.schedule(function()
  require "mappings"
end)
