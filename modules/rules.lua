local awful = require("awful")
local beautiful = require("beautiful")
local bindings = require("modules/bindings")
local screen_left = 2
local screen_right = 1

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = 0,
      focus = awful.client.focus.filter,
      raise = true,
      keys = bindings.clientkeys,
      buttons = bindings.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.centered,
      xindex = 0,
      xkeys = true
    },
    callback=function(c)
      if c.fullscreen then
        c.fullscreen = false
        c.fullscreen = true
      end
    end
  },
  {
    rule = {class = "firefox"},
    properties = {
      maximized = true,
      xindex = 1
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
    rule = {instance = "Steam"},
    properties = {
      xindex = 4.1,
      maximized = true
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
    rule = {instance = "VirtualBox Machine"},
    properties = {
      xindex = 8,
      maximized = false,
      xkeys = false
    }
  },
  -- Screen Right
  {
    rule = {instance = "dolphin"},
    properties = {
      placement = function(c)
        awful.placement.top_left(c, {honor_workarea = true})
      end, 
      width = width_factor(0.5),
      height = height_factor(0.5),
      maximized = false,
      xindex = 1,
      screen = screen_right           
    }
  },
  {
    rule = {instance = "audacious"},
    properties = {
      placement = function(c)
        awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = width_factor(0.5),
      height = height_factor(0.5),
      maximized = false,
      xindex = 2,
      screen = screen_right
    }
  },
  {
    rule = {instance = "hexchat"},
    properties = {
      placement = function(c)
        awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = width_factor(0.5),
      height = height_factor(1),
      maximized = false,
      xindex = 4,
      screen = screen_right
    }
  }
}

function check_title_rules(c)
  if startswith(c.name, "[ff_dev1]") then
    c.width = width_factor(0.5)
    c.height = height_factor(1)
    c.xindex = 1
    c.maximized = false
    c.border_width = 1
    awful.placement.left(c, {honor_workarea = true})
  end

  if startswith(c.name, "[ff_dev2]") then
    c.width = width_factor(0.5)
    c.height = height_factor(1)
    c.xindex = 2
    c.maximized = false
    c.border_width = 1
    awful.placement.right(c, {honor_workarea = true})
  end
end