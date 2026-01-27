require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

-- Disable arrow keys in normal, insert, and visual modes
map("n", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("n", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("n", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("n", "<Right>", "<Nop>", { desc = "Disable right arrow" })

map("i", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("i", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("i", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("i", "<Right>", "<Nop>", { desc = "Disable right arrow" })

map("v", "<Up>", "<Nop>", { desc = "Disable up arrow" })
map("v", "<Down>", "<Nop>", { desc = "Disable down arrow" })
map("v", "<Left>", "<Nop>", { desc = "Disable left arrow" })
map("v", "<Right>", "<Nop>", { desc = "Disable right arrow" })

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
