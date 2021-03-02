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
  -- Screen 1 Tag 1
  {
    rule = {class = "Firefox"},
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
    rule = {instance = "lutris"},
    properties = {
      xindex = 3
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
  -- Screen 2 Tag 1
  {
    rule_any = {
      instance = {"dolphin", "clementine", "hexchat", "konsole"},
      class = {"Nightly"}
    },
    properties = {
      screen = 2,
      tag = "1",
    }
  }, 
  {
    rule = {class = "Nightly"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 1
    }
  }, 
  {
    rule = {instance = "clementine"},
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
    rule = {instance = "konsole"},
    properties = {
      placement = function(c)
        return awful.placement.top_right(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.4,
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
      xindex = 4
    }
  },
  {
    rule = {instance = "dolphin"},
    properties = {
      placement = function(c)
        return awful.placement.top_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.4,
      xindex = 5,
    }
  },
}