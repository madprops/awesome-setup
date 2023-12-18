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
      x_dropdown_util_screen = false,
      x_keys = true,
      x_rules_applied = false,
      x_tiled = false,
      x_client = true,
      x_commands = false,
      x_index = 0,
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
      x_hotcorner = "1_top_left",
      x_index = 1,
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      maximized = true,
      x_commands = true,
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      maximized = false,
    }
  },
  {
    rule = {instance = "fl64.exe"},
    properties = {
      maximized = true,
    }
  },
  {
    rule = {instance = "VirtualBox Machine"},
    properties = {
      maximized = false,
      x_keys = false,
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
      screen = screen_right,
      x_tiled = true,
      x_index = 3,
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
      screen = screen_right,
      x_alt_q = true,
      x_tiled = true,
      x_index = 4,
    }
  },
  -- Util Screen
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
      x_dropdown_util_screen = true,
      x_commands = true,
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
      x_dropdown_util_screen = true,
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
      x_dropdown_util_screen = true,
      x_commands = true,
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
      x_commands = true,
    }
  },
}

function Rules.check_title_rules(c, force)
  if force == nil then
    force = false
  end

  if Utils.startswith(c.name, "[ff_tile1]") then
    if not c.x_rules_applied or force then
      awful.placement.top_left(c, {honor_workarea = true})
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.64)
      c.maximized = false
      c.x_rules_applied = true
      c.x_tiled = true
      c.x_index = 1
    end
  end

  if Utils.startswith(c.name, "[ff_tile2]") then
    if not c.x_rules_applied or force then
      awful.placement.bottom_left(c, {honor_workarea = true})
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.36)
      c.maximized = false
      c.x_rules_applied = true
      c.x_tiled = true
      c.x_index = 2
    end
  end

  if Utils.startswith(c.name, "[ff_tile3]") then
    if not c.x_rules_applied or force then
      awful.placement.top_right(c, {honor_workarea = true})
      c.width = Utils.width_factor(0.5)
      c.height = Utils.height_factor(0.64)
      c.maximized = false
      c.x_rules_applied = true
      c.x_tiled = true
      c.x_index = 3
    end
  end

  if Utils.startswith(c.name, "[chatgpt]") then
    if not c.x_rules_applied or force then
      c.width = Utils.width_factor(1)
      c.height = Utils.height_factor(1)
      c.maximized = true
      c.skip_taskbar = true
      c.x_rules_applied = true
      c.x_dropdown_chat_gpt = true
    end
  end
end

function Rules.reset_rules(c)
  awful.rules.apply(c)
  Rules.check_title_rules(c)
end