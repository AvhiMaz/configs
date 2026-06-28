local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")

map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

map("n", "[d", function() vim.diagnostic.jump { count = -1, float = true } end, { desc = "Prev diagnostic" })
map("n", "]d", function() vim.diagnostic.jump { count = 1, float = true } end, { desc = "Next diagnostic" })
map("n", "<leader>df", vim.diagnostic.open_float, { desc = "Diagnostic float" })
map("n", "<leader>dl", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
map("n", "<leader>dq", vim.diagnostic.setqflist, { desc = "Diagnostics to quickfix" })

map("n", "<C-\\>", function()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == "compilation" then
      vim.api.nvim_set_current_win(w)
      return
    end
  end
end)

map("n", "<Up>", "<Nop>")
map("n", "<Down>", "<Nop>")
map("n", "<Left>", "<Nop>")
map("n", "<Right>", "<Nop>")

map("i", "<Up>", "<Nop>")
map("i", "<Down>", "<Nop>")
map("i", "<Left>", "<Nop>")
map("i", "<Right>", "<Nop>")

map("v", "<Up>", "<Nop>")
map("v", "<Down>", "<Nop>")
map("v", "<Left>", "<Nop>")
map("v", "<Right>", "<Nop>")
