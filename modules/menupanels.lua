local awful = require("awful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}
local placement = "bottom"
local height = 25

menupanels.utils = {}

function menupanels.utils.showinfo(text)
  menupanels.info.update_item(1, text)
  menupanels.info.show_with_delay()
end

menupanels.main = menupanel.create({
  placement = placement,
  height = height,
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
      name = "Players",
      action = function() menupanels.players.show() end,
    },
    {
      name = "Leave",
      action = function() menupanels.leave.show() end,
    },
  }
})

menupanels.applications = menupanel.create({
  placement = placement,
  height = height,
  parent = menupanels.main,
  items = {
    {
      name = "Firefox Dev 1",
      action = function() spawn("firefox -P dev1") end,
    },
    {
      name = "Firefox Dev 2",
      action = function() spawn("firefox -P dev2") end,
    },
    {
      name = "Firefox Dev 3",
      action = function() spawn("firefox -P dev3") end,
    },
    {
      name = "Keyboard",
      action = function() spawn("onboard") end,
    }
  }
})

menupanels.log = menupanel.create({
  placement = placement,
  height = height,
  parent = menupanels.main,
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
      name = "Bath",
      action = function() add2log("Bath") end,
      needs_confirm = true,
    },
    {
      name = "Meds",
      action = function() add2log("Meds") end,
      needs_confirm = true,
    }
  }
})

menupanels.players = menupanel.create({
  placement = placement,
  height = height,
  parent = menupanels.main,
  items = {
    {
      name = "Spotify",
      action = function() change_player("spotify") end
    },
    {
      name = "Strawberry",
      action = function() change_player("strawberry") end
    },
    {
      name = "Goodvibes",
      action = function() change_player("Goodvibes") end
    },
    {
      name = "Firefox",
      action = function() change_player("firefox") end
    },
  }
})

menupanels.leave = menupanel.create({
  placement = placement,
  height = height, 
  parent = menupanels.main,
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
      action = function() shellspawn("reboot") end,
      needs_confirm = true,
    },
    {
      name = "Shutdown",
      action = function() shellspawn("shutdown now") end,
      needs_confirm = true,
    },
  }
})

menupanels.context = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "Maximize",
      action = function() maximize(get_context_client()) end,
    },
    {
      name = "Fullscreen",
      action = function() fullscreen(get_context_client()) end,
    },
    {
      name = "Float",
      action = function() float(get_context_client()) end,
    },
    {
      name = "Title",
      action = function() show_client_title(get_context_client()) end
    },
    {
      name = "Close",
      action = function() close(get_context_client()) end,
      needs_confirm = true,
    },
  }
})

menupanels.info = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "- Empty -",
      action = function() 
        to_clipboard(menupanels.info.get_item(1).name) 
      end,
    },
  }
})

return menupanels