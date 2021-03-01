local awful = require("awful")
local beautiful = require("beautiful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}

menupanels.main = menupanel.create({ 
  items = {
    {
      name = "Launch an Application",
      action = function() menupanels.applications.show() end,
    },
    {
      name = "Leave",
      action = function() menupanels.leave.show() end,
    },
  }
})

menupanels.applications = menupanel.create({
  items = {
    {
      name = "Browsers",
      action = function() menupanels.browsers.show() end,
    },
    {
      name = "Code",
      action = function() awful.util.spawn("code", false) end,
    },
    {
      name = "Music",
      action = function() menupanels.music.show() end,
    },
    {
      name = "Vidya",
      action = function() menupanels.vidya.show() end,
    }
  }
})

menupanels.browsers = menupanel.create({ 
  items = {
    {
      name = "Firefox",
      action = function() awful.util.spawn("firefox", false) end,
      hide_on_click = false,
    },
    {
      name = "Firefox Dev 1",
      action = function() awful.util.spawn("firefox -P dev1", false) end,
      hide_on_click = false,
    },
    {
      name = "Firefox Dev 2",
      action = function() awful.util.spawn("firefox -P dev2", false) end,
      hide_on_click = false,
    },
    {
      name = "Nightly",
      action = function() awful.util.spawn("firefox-trunk", false) end,
      hide_on_click = false,
    },
    {
      name = "Chromium",
      action = function() awful.util.spawn("chromium", false) end,
      hide_on_click = false,
    },
  }
})

menupanels.vidya = menupanel.create({ 
  items = {
    {
      name = "Lutris",
      action = function() awful.util.spawn("lutris", false) end,
      hide_on_click = false,
    },
    {
      name = "Steam",
      action = function() awful.util.spawn("steam", false) end,
      hide_on_click = false,
    },
  }
})

menupanels.music = menupanel.create({ 
  items = {
    {
      name = "Spotify",
      action = function() awful.util.spawn("spotify", false) end,
      hide_on_click = false,
    },
    {
      name = "Clementine",
      action = function() awful.util.spawn("clementine", false) end,
      hide_on_click = false,
    },
  }
})

menupanels.leave = menupanel.create({ 
  items = {
    {
      name = "Restart",
      action = function() menupanels.confirm("Restart", function() awesome.restart() end) end,
    },
    {
      name = "Logout",
      action = function() menupanels.confirm("Logout", function() awesome.quit() end) end,
    },
    {
      name = "Suspend",
      action = function() menupanels.confirm("Suspend", function() awful.spawn.with_shell("systemctl suspend") end) end,
    },
    {
      name = "Reboot",
      action = function() menupanels.confirm("Reboot", function() awful.spawn.with_shell("reboot") end) end,
    },
    {
      name = "Shutdown",
      action = function() menupanels.confirm("Shutdown", function() awful.spawn.with_shell("shutdown now") end) end,
    },
  }
})

function menupanels.confirm(label, func)
  local confirm = menupanel.create({ 
    items = {
      {
        name = "Confirm "..label,
        action = function() func() end,
      },
      {
        name = "Cancel",
        action = function() end,
      }
    }
  })

  confirm.show()
end

return menupanels