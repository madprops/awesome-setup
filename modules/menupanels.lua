Menupanels = {}

local menupanel = require("madwidgets/menupanel/menupanel")

local placement = "bottom"
local height = 25

Menupanels.utils = {}

function Menupanels.utils.showinfo(text)
  Menupanels.info.update_item(1, text)
  Menupanels.info.start("mouse")
end

Menupanels.main = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "Launch",
      action = function(trigger) Menupanels.applications.show(trigger) end,
    },
    {
      name = "Log",
      action = function(trigger) Menupanels.log.show(trigger) end,
    },
    {
      name = "Leave",
      action = function(trigger) Menupanels.leave.show(trigger) end,
    },
  }
})

Menupanels.applications = menupanel.create({
  placement = placement,
  height = height,
  parent = Menupanels.main,
  items = {
    {
      name = "Firefox Tile 1",
      action = function() Utils.spawn("firefox-developer-edition -P tile1") end,
    },
    {
      name = "Firefox Tile 2",
      action = function() Utils.spawn("firefox-developer-edition -P tile2") end,
    },
    {
      name = "Firefox Dev 1",
      action = function() Utils.spawn("firefox-developer-edition -P dev1") end,
    },
    {
      name = "Firefox Dev 2",
      action = function() Utils.spawn("firefox-developer-edition -P dev2") end,
    },
    {
      name = "Firefox Dev 3",
      action = function() Utils.spawn("firefox-developer-edition -P dev3") end,
    },
    {
      name = "Keyboard",
      action = function() Utils.spawn("onboard") end,
    }
  }
})

Menupanels.log = menupanel.create({
  placement = placement,
  height = height,
  parent = Menupanels.main,
  items = {
    {
      name = "Show Log",
      action = function() Utils.show_log() end,
    },
    {
      name = "Wake",
      action = function() Utils.add_to_log("Wake", true) end,
      needs_confirm = true,
    },
    {
      name = "Meds 1",
      action = function() Utils.add_to_log("Meds 1", true) end,
      needs_confirm = true,
    },
    {
      name = "Meds 2",
      action = function() Utils.add_to_log("Meds 2", true) end,
      needs_confirm = true,
    }
  }
})

Menupanels.leave = menupanel.create({
  placement = placement,
  height = height,
  parent = Menupanels.main,
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
      action = function(trigger) Menupanels.suspend.show(trigger) end,
    },
    {
      name = "Reboot",
      action = function() Utils.shellspawn("reboot") end,
      needs_confirm = true,
    },
    {
      name = "Shutdown",
      action = function() Utils.shellspawn("shutdown now") end,
      needs_confirm = true,
    },
  }
})

Menupanels.suspend = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "Now",
      action = function() Utils.suspend() end,
      needs_confirm = true,
    },
    {
      name = "5 minutes",
      action = function() Utils.auto_suspend(5) end,
      needs_confirm = true,
    },
    {
      name = "30 minutes",
      action = function() Utils.auto_suspend(30) end,
      needs_confirm = true,
    },
    {
      name = "60 minutes",
      action = function() Utils.auto_suspend(60) end,
      needs_confirm = true,
    },
    {
      name = "90 minutes",
      action = function() Utils.auto_suspend(90) end,
      needs_confirm = true,
    }
  }
})

Menupanels.context = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "Maximize",
      action = function() Utils.maximize(Utils.get_context_client()) end,
    },
    {
      name = "Fullscreen",
      action = function() Utils.fullscreen(Utils.get_context_client()) end,
    },
    {
      name = "On Top",
      action = function() Utils.on_top(Utils.get_context_client()) end,
    },
    {
      name = "Center",
      action = function() Utils.center(Utils.get_context_client()) end,
    },
    {
      name = "Reset",
      action = function() Utils.reset_rules(Utils.get_context_client()) end,
    },
    {
      name = "Close",
      action = function() Utils.close(Utils.get_context_client()) end,
      needs_confirm = true,
    },
  }
})

Menupanels.info = menupanel.create({
  placement = placement,
  height = height,
  items = {
    {
      name = "- Empty -",
      action = function()
        Utils.to_clipboard(Menupanels.info.get_item(1).name)
      end,
    },
  }
})