local beautiful = require("beautiful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}

menupanels.main = menupanel.create({ 
  items = {
    {
      name = "Launch an Application",
      action = function() launcher() end,
    },
    {
      name = "Apply Layout",
      action = function() layoutsmenu() end,
    },
    {
      name = "Open Symbols Picker",
      action = function()
          symbolsmenu()
      end,
    },
    {
      name = "Leave",
      action = function() leavemenu() end,
    },
  }
})

menupanels.symbols = menupanel.create({ 
  items = {
    {
      name = "$",
      action = function() typestring("$") end,
      hide_on_click = false,
    },
    {
      name = "%",
      action = function() typestring("%") end,
      hide_on_click = false,
    },
    {
      name = "^",
      action = function() typestring("^") end,
      hide_on_click = false,
    },
    {
      name = "&",
      action = function() typestring("&") end,
      hide_on_click = false,
    },
    {
      name = "*",
      action = function() typestring("*") end,
      hide_on_click = false,
    },
  }
})

menupanels.confirm = menupanel.create({ 
  items = {
    {
      name = "Confirm",
      action = function() exec_confirm() end,
    },
    {
      name = "Cancel",
      action = function() end,
    }
  }
})

menupanels.layouts = menupanel.create({ 
  items = {
    {
      name = "Left / Right",
      action = function() apply_layout("left_right") end,
      hide_on_click = true,
    },
    {
      name = "Up / Down",
      action = function() apply_layout("up_down") end,
    },
  }
})

menupanels.leave = menupanel.create({ 
  items = {
    {
      name = "Restart",
      action = function() needs_confirm(function() awesome.restart() end) end,
    },
    {
      name = "Logout",
      action = function() needs_confirm(function() awesome.quit() end) end,
    },
    {
      name = "Sleep",
      action = function() needs_confirm(function() awful.spawn.with_shell("systemctl suspend") end) end,
    },
    {
      name = "Reboot",
      action = function() needs_confirm(function() awful.spawn.with_shell("reboot") end) end,
    },
    {
      name = "Shutdown",
      action = function() needs_confirm(function() awful.spawn.with_shell("shutdown now") end) end,
    },
  }
})

return menupanels