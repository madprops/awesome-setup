local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("modules/bindings")

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = 0,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = bindings.clientkeys,
      buttons = bindings.clientbuttons,
      screen = awful.screen.preferred,
      placement = function(c)
        return awful.placement.centered(c, {honor_workarea = true})
      end,
      xindex = 0
    }
  },
  {
    rule = {instance = "vivaldi-stable"},
    properties = {
      xindex = 1
    }
  },
  {
    rule = {class = "Firefox"},
    properties = {
      xindex = 2
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      xindex = 2
    }
  },
  {
    rule = {instance = "strawberry"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 2
    }
  },
  {
    rule = {instance = "lutris"},
    properties = {
      xindex = 3
    }
  },
  {
    rule = {instance = "hexchat"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 4,
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      xindex = 4
    }
  },
  {
    rule = {instance = "fl64.exe"},
    properties = {
      xindex = 5,
      maximized = true
    }
  },
  {
    rule = {instance = "dolphin"},
    properties = {
      xindex = 5,
    }
  },
  {
    rule = {instance = "pulseeffects"},
    properties = {
      xindex = 6
    }
  }
}