local M = {}

local history_file = vim.fn.stdpath("data") .. "/compile_history"
local history = {}

local function load_history()
  local f = io.open(history_file, "r")
  if not f then return end
  for line in f:lines() do
    if line ~= "" then table.insert(history, line) end
  end
  f:close()
end

local function save_history(cmd)
  for i, v in ipairs(history) do
    if v == cmd then table.remove(history, i); break end
  end
  table.insert(history, 1, cmd)
  while #history > 10000 do table.remove(history) end
  local f = io.open(history_file, "w")
  if not f then return end
  for _, v in ipairs(history) do f:write(v .. "\n") end
  f:close()
end

local function run(cmd)
  save_history(cmd)
  vim.api.nvim_cmd({ cmd = "Compile", args = { cmd } }, {})
end

function M.compile(default)
  local last = default or vim.g.compile_command or ""
  local cmd = vim.fn.input({ prompt = "Compile: ", default = last, completion = "shellcmd" })
  if cmd == "" then return end
  run(cmd)
end

function M.history()
  if #history == 0 then
    vim.notify("No compile history", vim.log.levels.INFO)
    return
  end
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers.new({}, {
    prompt_title = "Compile History",
    finder = finders.new_table { results = history },
    sorter = conf.generic_sorter({}),
    attach_mappings = function(buf, _)
      actions.select_default:replace(function()
        actions.close(buf)
        M.compile(action_state.get_selected_entry()[1])
      end)
      return true
    end,
  }):find()
end

local function jump_to_code()
  for _, w in ipairs(vim.api.nvim_list_wins()) do
    if vim.bo[vim.api.nvim_win_get_buf(w)].filetype ~= "compilation" then
      vim.api.nvim_set_current_win(w)
      return
    end
  end
end

local function setup_buf(ev)
  local MAX_LINES = 5000
  local timer = vim.uv.new_timer()
  timer:start(0, 300, vim.schedule_wrap(function()
    if not vim.api.nvim_buf_is_valid(ev.buf) then
      timer:stop()
      timer:close()
      return
    end
    local count = vim.api.nvim_buf_line_count(ev.buf)
    if count > MAX_LINES * 2 then
      vim.api.nvim_buf_set_lines(ev.buf, 0, count - MAX_LINES, false, {})
    end
  end))

  vim.api.nvim_create_autocmd("BufDelete", {
    buffer = ev.buf,
    once = true,
    callback = function()
      timer:stop()
      timer:close()
    end,
  })

  vim.keymap.set("n", "<cr>", function()
    local line = vim.api.nvim_get_current_line()
    local file, lnum, col = line:match("%-%->%s+(.+):(%d+):(%d+)")
    if not file then file, lnum = line:match("%-%->%s+(.+):(%d+)") end
    if not file then file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+error") end
    if not file then file, lnum, col = line:match("^%s*(.+):(%d+):(%d+):%s+warning") end
    if not file then return end

    local compile_win = vim.api.nvim_get_current_win()
    local target_win = nil
    for _, w in ipairs(vim.api.nvim_list_wins()) do
      if w ~= compile_win then
        local buf = vim.api.nvim_win_get_buf(w)
        if vim.bo[buf].filetype ~= "compilation" then
          target_win = w
          if vim.api.nvim_buf_get_name(buf):find(file, 1, true) then break end
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
  vim.keymap.set("n", "<C-\\>", jump_to_code, { buffer = true, silent = true })
end

function M.setup()
  vim.g.compile_mode = {
    recompile_no_fail = true,
    environment = { MANPAGER = "col -b", PAGER = "col -b" },
  }
  load_history()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "compilation",
    callback = setup_buf,
  })
end

return M
