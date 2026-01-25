local source = {}

source.new = function()
  local self = setmetatable({}, { __index = source })
  self.history = nil
  self.last_load = 0
  return self
end

source.get_keyword_pattern = function()
  return [[\S\+]]
end

source.get_trigger_characters = function()
  return { "!" }
end

function source:load_history()
  local now = os.time()
  if self.history and (now - self.last_load) < 60 then
    return self.history
  end

  local history = {}
  local seen = {}
  local histfile = os.getenv("HISTFILE") or vim.fn.expand("~/.zsh_history")

  local file = io.open(histfile, "r")
  if not file then
    return history
  end

  for line in file:lines() do
    local cmd = line:match("^: %d+:%d+;(.+)$")
    if not cmd then
      cmd = line
    end

    if cmd and cmd ~= "" and not seen[cmd] then
      seen[cmd] = true
      table.insert(history, 1, cmd)
    end
  end
  file:close()

  self.history = history
  self.last_load = now
  return history
end

function source:complete(params, callback)
  local cmdline = params.context.cursor_line
  if not cmdline:match("^!") then
    callback({ items = {}, isIncomplete = false })
    return
  end

  local input = cmdline:sub(2)
  local history = self:load_history()
  local items = {}

  for _, cmd in ipairs(history) do
    if input == "" or cmd:lower():find(input:lower(), 1, true) then
      table.insert(items, {
        label = cmd,
        kind = require("cmp.types").lsp.CompletionItemKind.Text,
        sortText = string.format("%010d", #items),
      })
    end
    if #items >= 100 then
      break
    end
  end

  callback({ items = items, isIncomplete = false })
end

function source:get_debug_name()
  return "zsh_history"
end

require("cmp").register_source("zsh_history", source.new())

return source
