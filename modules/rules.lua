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
      xindex = 0,
      xkeys = true
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
      maximized = false,
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
    rule = {instance = "youtube-music-desktop-app"},
    properties = {
      xindex = 3.1,
      maximized = true
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
      xindex = 3.2,
      maximized = false
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
      maximized = false
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      xindex = 4.1,
      maximized = false
    }
  },
  {
    rule = {instance = "lutris"},
    properties = {
      xindex = 4.2,
      maximized = false
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
      xindex = 6,
      maximized = false
    }
  },
  {
    rule = {instance = "ocenaudio"},
    properties = {
      xindex = 7,
      maximized = false
    }
  },
  {
    rule = {instance = "VirtualBox Machine"},
    properties = {
      xindex = 8,
      maximized = false,
      xkeys = false
    }
  } 
}
