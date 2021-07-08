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
    rule = {class = "Firefox"},
    properties = {
      xindex = 1
    }
  },
  {
    rule = {instance = "vivaldi-stable"},
    properties = {
      xindex = 1
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      xindex = 2
    }
  },
  {
    rule = {instance = "spotify"},
    properties = {
      maximized = true,
      xindex = 3.1
    }
  },
  {
    rule = {instance = "strawberry"},
    properties = {
      xindex = 3.2
    }
  },
  {
    rule = {instance = "goodvibes"},
    properties = {
      xindex = 3.3
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
  {
    rule = {instance = "xdg-desktop-portal-kde"},
    properties = {
      width = awful.screen.focused().workarea.width * 0.8,
      height = awful.screen.focused().workarea.height * 0.8,
    }
  },
}
