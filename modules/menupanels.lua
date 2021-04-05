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
      action = function() add2log("Wake") end,
      needs_confirm = true,
    },
    {
      name = "Meds",
      action = function() add2log("Meds") end,
      needs_confirm = true,
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
      action = function() awesome.restart() end,
      needs_confirm = true,
    },
    {
      name = "Logout",
      action = function() awesome.quit() end,
      needs_confirm = true,
    },
    {
      name = "Suspend",
      action = function() lockscreen(true) end,
      needs_confirm = true,
    },
    {
      name = "Reboot",
      action = function() awful.spawn.with_shell("reboot") end,
      needs_confirm = true,
    },
    {
      name = "Shutdown",
      action = function() awful.spawn.with_shell("shutdown now") end,
      needs_confirm = true,
    },
  }
})

return menupanels