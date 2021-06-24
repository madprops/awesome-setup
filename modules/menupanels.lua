local awful = require("awful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}
local placement = "bottom"
local height = 25

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
      name = "Vivaldi Dev 1",
      action = function() spawn("vivaldi-stable --profile-directory=dev1") end,
    },
    {
      name = "Vivaldi Dev 2",
      action = function() spawn("vivaldi-stable --profile-directory=dev2") end,
    },
    {
      name = "Vivaldi Dev 3",
      action = function() spawn("vivaldi-stable --profile-directory=dev3") end,
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
      action = function()
        menupanels.title.update_item(1, get_context_client().name)
        menupanels.title.show()
      end,
    },
    {
      name = "Close",
      action = function() close(get_context_client()) end,
      needs_confirm = true,
    },
  }
})

menupanels.title = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "- Empty -",
      action = function()  end,
    },
  }
})

return menupanels