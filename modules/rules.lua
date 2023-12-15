Rules = {}

local awful = require("awful")
local screen_left = 1
local screen_right = 2

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = 0,
      focus = awful.client.focus.filter,
      raise = true,
      keys = Bindings.clientkeys,
      buttons = Bindings.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.centered,
      xindex = 0,
      xkeys = true,
      xutil_screen = false,
      xrules_applied = false,
      xtiled = false,
      xclient = true,
      xcommands = false,
    },
    callback=function(c)
      if c.fullscreen then
        c.fullscreen = false
        c.fullscreen = true
      end
    end
  },
  {
    rule = {class = "firefoxdeveloperedition"},
    properties = {
      maximized = true,
      xindex = 1,
      xhotcorner = "1_top_left",
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      maximized = true,
      xindex = 2,
      xcommands = true,
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      xindex = 4.1,
      maximized = false,
    }
  },
  {
    rule = {instance = "lutris"},
    properties = {
      xindex = 4.2,
      maximized = false,
    }
  },
  {
    rule = {instance = "fl64.exe"},
    properties = {
      xindex = 5,
      maximized = true,
    }
  },
  {
    rule = {instance = "VirtualBox Machine"},
    properties = {
      xindex = 8,
      maximized = false,
      xkeys = false,
    }
  },
  -- Screen Right
  {
    rule = {instance = "hexchat"},
    properties = {
      placement = function(c)
        awful.placement.top_right(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.5),
      height = Utils.height_factor(0.64),
      maximized = false,
      xindex = 3,
      screen = screen_right,
      xtiled = true,
    }
  },
  {
    rule = {instance = "chromium"},
    properties = {
      placement = function(c)
        awful.placement.top_right(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.5),
      height = Utils.height_factor(0.64),
      maximized = false,
      xindex = 3,
      screen = screen_right,
      xtiled = true,
    }
  },
  {
    rule = {instance = "audacious"},
    properties = {
      placement = function(c)
        awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.5),
      height = Utils.height_factor(0.36),
      maximized = false,
      xindex = 4,
      screen = screen_right,
      xtiled = true,
      xalt_q = true,
    }
  },
  {
    rule = {instance = "com.github.taiko2k.tauonmb"},
    properties = {
      placement = function(c)
        awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.5),
      height = Utils.height_factor(0.36),
      maximized = false,
      xindex = 4,
      screen = screen_right,
      xtiled = true,
    }
  },
  -- Util screen
  {
    rule = {instance = "dolphin"},
    properties = {
      placement = function(c)
        awful.placement.top_left(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.75),
      height = Utils.height_factor(0.5),
      maximized = false,
      skip_taskbar = true,
      xutil_screen = true,
      xcommands = true,
    }
  },
  {
    rule = {instance = "speedcrunch"},
    properties = {
      placement = function(c)
        awful.placement.top_right(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.25),
      height = Utils.height_factor(0.5),
      maximized = false,
      skip_taskbar = true,
      xutil_screen = true,
    }
  },
  {
    rule = {instance = "tilix"},
    properties = {
      placement = function(c)
        awful.placement.bottom(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(1),
      height = Utils.height_factor(0.5),
      maximized = false,
      skip_taskbar = true,
      xutil_screen = true,
      xcommands = true,
    }
  },
  -- Other Rules
  {
    rule = {instance = "Alacritty"},
    properties = {
      placement = function(c)
        awful.placement.centered(c, {honor_workarea = true})
      end,
      width = Utils.width_factor(0.7),
      height = Utils.height_factor(0.7),
      maximized = false,
      xcommands = true,
    }
  },
}

function Rules.check_title_rules(c, force)
  if force == nil then
    force = false
  end

  if Utils.startswith(c.name, "[ff_tile1]") then
    if not c.xrules_applied or force then
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.64)
      c.xindex = 1
      c.maximized = false
      awful.placement.top_left(c, {honor_workarea = true})
      c.xrules_applied = true
      c.xtiled = true
    end
  end

  if Utils.startswith(c.name, "[ff_tile2]") then
    if not c.xrules_applied or force then
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.36)
      c.xindex = 2
      c.maximized = false
      awful.placement.bottom_left(c, {honor_workarea = true})
      c.xrules_applied = true
      c.xtiled = true
    end
  end

  if Utils.startswith(c.name, "[ff_tile3]") then
    if not c.xrules_applied or force then
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.64)
      c.xindex = 3
      c.maximized = false
      awful.placement.top_right(c, {honor_workarea = true})
      c.xrules_applied = true
      c.xtiled = true
    end
  end

  if Utils.startswith(c.name, "[chatgpt]") then
    if not c.xrules_applied or force then
      c.width = Utils.width_factor(1)
      c.height = Utils.height_factor(1)
      c.maximized = true
      c.xrules_applied = true
      c.xchat_gpt = true
      c.skip_taskbar = true
    end
  end
end

function Rules.reset_rules(c)
  awful.rules.apply(c)
  Rules.check_title_rules(c)
end