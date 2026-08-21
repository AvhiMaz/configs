local M = {}

function M.find_files_anywhere()
  require("telescope.builtin").find_files({
    prompt_title = "Find File (Anywhere)",
    cwd = vim.fn.expand("~"),
    find_command = {
      "fd", "--type", "f", "--hidden",
      "--exclude", ".git",
      "--exclude", "node_modules",
      "--exclude", "target",
      "--exclude", "Library",
    },
  })
end

function M.pick_dir()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  pickers
    .new({}, {
      prompt_title = "Directories",
      finder = finders.new_oneshot_job({
        "fd",
        "--type",
        "d",
        "--exclude",
        ".git",
        "--exclude",
        "node_modules",
        "--exclude",
        "target",
        ".",
        vim.fn.expand("~/Dev"),
        vim.fn.expand("~/dev"),
      }, {}),
      sorter = conf.file_sorter({}),
      attach_mappings = function(prompt_bufnr)
        actions.select_default:replace(function()
          local selection = action_state.get_selected_entry()
          if not selection then
            return
          end
          actions.close(prompt_bufnr)
          require("telescope.builtin").find_files({ cwd = selection[1] })
        end)
        return true
      end,
    })
    :find()
end

return M
