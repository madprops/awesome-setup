local awful = require("awful")
local beautiful = require("beautiful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}

menupanels.main = menupanel.create({ 
  items = {
    {
      name = "Launch",
      action = function() menupanels.applications.show() end,
    },
    {
      name = "Log",
      action = function() menupanels.log.show() end,
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

menupanels.log = menupanel.create({
  items = {
    {
      name = "Show Log",
      action = function() showlog() end,
    },
    {
      name = "Wake",
      action = function() menupanels.confirm("Log Wake", function() add2log("Wake") end) end,
    },
    {
      name = "Meds",
      action = function() menupanels.confirm("Log Meds", function() add2log("Meds") end) end,
    }
  }
})

menupanels.browsers = menupanel.create({ 
  items = {
    {
      name = "Vivaldi",
      action = function() awful.util.spawn("vivaldi-stable", false) end,
    },
    {
      name = "Vivaldi Dev 1",
      action = function() awful.util.spawn("vivaldi-stable --profile-directory=dev1", false) end,
    },
    {
      name = "Vivaldi Dev 2",
      action = function() awful.util.spawn("vivaldi-stable --profile-directory=dev2", false) end,
    },
    {
      name = "Vivaldi Dev 3",
      action = function() awful.util.spawn("vivaldi-stable --profile-directory=dev3", false) end,
    }
  }
})

menupanels.vidya = menupanel.create({ 
  items = {
    {
      name = "Lutris",
      action = function() awful.util.spawn("lutris", false) end,
    },
    {
      name = "Steam",
      action = function() awful.util.spawn("steam", false) end,
    },
  }
})

menupanels.music = menupanel.create({ 
  items = {
    {
      name = "Spotify",
      action = function() awful.util.spawn("spotify", false) end,
    },
    {
      name = "Clementine",
      action = function() awful.util.spawn("clementine", false) end,
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
      action = function() menupanels.confirm("Suspend", function() lockscreen(true) end) end,
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
    }
  })

  confirm.show()
end

return menupanels