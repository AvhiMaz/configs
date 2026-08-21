require("copilot").setup {
  logger = { file_log_level = vim.log.levels.TRACE },
  suggestion = {
    enabled = true,
    auto_trigger = true,
    keymap = {
      accept = false,
      next = false,
      prev = false,
      dismiss = false,
    },
  },
  panel = { enabled = false },
}

vim.keymap.set("i", "<C-g>", function() require("copilot.suggestion").next() end)
vim.keymap.set("i", "<C-l>", function() require("copilot.suggestion").accept() end)
vim.keymap.set("i", "<C-x>", function() require("copilot.suggestion").dismiss() end)
