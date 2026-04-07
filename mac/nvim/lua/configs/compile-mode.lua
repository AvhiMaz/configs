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
  while #history > 50 do table.remove(history) end
  local f = io.open(history_file, "w")
  if not f then return end
  for _, v in ipairs(history) do f:write(v .. "\n") end
  f:close()
end

local function run(cmd)
  save_history(cmd)
  vim.api.nvim_cmd({ cmd = "Compile", args = { cmd } }, {})
end

function M.compile()
  local last = vim.g.compile_command or ""
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
        run(action_state.get_selected_entry()[1])
      end)
      return true
    end,
  }):find()
end

load_history()
return M
