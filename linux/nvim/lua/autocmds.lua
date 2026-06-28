vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  callback = function() vim.cmd("checktime") end,
})

vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
