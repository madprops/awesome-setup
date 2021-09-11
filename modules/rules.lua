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
      placement = awful.placement.centered,
      xindex = 0
    }
  },
  {
    rule = {class = "Nightly"},
    properties = {
      maximized = true,
      xindex = 1
    }
  },
  {
    rule = {class = "Firefox"},
    properties = {
      maximized = true,
      xindex = 1.1
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      maximized = true,
      xindex = 2
    }
  },
  {
    rule = {instance = "psst-gui"},
    properties = {
      placement = function(c)
        awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = width_factor(0.5),
      height = height_factor(1),
      xindex = 3.1
    }
  },
  {
    rule = {instance = "strawberry"},
    properties = {
      placement = function(c)
        awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = width_factor(0.5),
      height = height_factor(0.6),
      xindex = 3.2
    }
  },
  {
    rule = {instance = "hexchat"},
    properties = {
      placement = function(c)
        awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = width_factor(0.5),
      height = height_factor(0.6),
      xindex = 4,
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      xindex = 4.1
    }
  },
  {
    rule = {instance = "lutris"},
    properties = {
      xindex = 4.2
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
    rule = {instance = "pulseeffects"},
    properties = {
      xindex = 5.1
    }
  },
  {
    rule = {instance = "dolphin"},
    properties = {
      xindex = 6,
    }
  },
}
