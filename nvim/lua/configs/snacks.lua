return {
  dashboard = {
    enabled = true,
    preset = {
      keys = {
        { icon = " ", key = "f", desc = "Find File", action = ":Telescope find_files" },
        { icon = " ", key = "r", desc = "Recent", action = ":Telescope oldfiles" },
        { icon = " ", key = "g", desc = "Grep", action = ":Telescope live_grep" },
        { icon = " ", key = "e", desc = "Explorer", action = ":Oil" },
        { icon = " ", key = "c", desc = "Config", action = ":e ~/dotfiles/nvim/lua/plugins/init.lua" },
        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
        { icon = " ", key = "q", desc = "Quit", action = ":qa" },
      },
    },
    sections = {
      { section = "keys", gap = 1, padding = 1 },
      { section = "startup" },
    },
  },
  bigfile = { enabled = false },
  notifier = { enabled = false },
  quickfile = { enabled = false },
  statuscolumn = { enabled = false },
  words = { enabled = false },
}
