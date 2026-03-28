vim.api.nvim_create_autocmd("FileType", {
  pattern = "compilation",
  callback = function()
    vim.keymap.set("n", "<cr>", function()
      local line = vim.api.nvim_get_current_line()
      local file, lnum, col = line:match("%-%->%s+(.+):(%d+):(%d+)")
      if not file then
        file, lnum = line:match("%-%->%s+(.+):(%d+)")
      end
      if not file then
        file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+error")
      end
      if not file then
        file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+warning")
      end
      if not file then return end

      local compile_win = vim.api.nvim_get_current_win()
      local target_win = nil

      for _, w in ipairs(vim.api.nvim_list_wins()) do
        if w ~= compile_win then
          local buf = vim.api.nvim_win_get_buf(w)
          if vim.bo[buf].filetype ~= "compilation" then
            target_win = w
            if vim.api.nvim_buf_get_name(buf):find(file, 1, true) then
              break
            end
          end
        end
      end

      if target_win then
        vim.api.nvim_set_current_win(target_win)
      else
        vim.cmd("wincmd p")
      end

      vim.cmd("e " .. file)
      if lnum then
        vim.api.nvim_win_set_cursor(0, { tonumber(lnum), col and (tonumber(col) - 1) or 0 })
      end
    end, { buffer = true, silent = true })

    vim.keymap.set("n", "<C-q>", "<cmd>QuickfixErrors<cr><cmd>copen<cr>", { buffer = true, silent = true })
  end,
})

vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function() vim.cmd("checktime") end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})

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
