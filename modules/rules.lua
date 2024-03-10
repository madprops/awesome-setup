local awful = require("awful")
local screen_left = 1
local screen_right = 2

Rules = {}

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
      skip_taskbar = false,
      x_keys = true,
      x_rules_applied = false,
      x_client = true,
      x_commands = false,
      x_dropdown_gpt = false,
      x_dropdown_utils = false,
      x_index = 0,
      x_focus_date = 0,
      x_frame = "none",
      x_frame_ready = false,
      x_alt_q = false,
      x_ctrl_d = false,
    },
    callback = function(c)
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
      x_frame = "bottom_left",
      x_index = 10,
    }
  },
  {
    rule = {instance = "audacious"},
    properties = {
      x_frame = "bottom_right",
      x_alt_q = true,
    }
  },
  {
    rule = {instance = "strawberry"},
    properties = {
      x_frame = "bottom_right",
      x_ctrl_d = true,
    }
  },
  {
    rule = {instance = "Devtools"},
    properties = {
      maximized = true,
      screen = screen_right,
      x_index = 1,
    }
  },
  -- Util Screen
  {
    rule = {instance = "dolphin"},
    properties = {
      maximized = false,
      placement = function(c)
        Utils.placement(c, "top_left")
      end,
      width = Utils.width_factor(0.75),
      height = Utils.height_factor(0.5),
      skip_taskbar = true,
      x_dropdown_utils = true,
      x_commands = true,
    }
  },
  {
    rule = {instance = "speedcrunch"},
    properties = {
      maximized = false,
      placement = function(c)
        Utils.placement(c, "top_right")
      end,
      width = Utils.width_factor(0.25),
      height = Utils.height_factor(0.5),
      skip_taskbar = true,
      x_dropdown_utils = true,
    }
  },
  {
    rule = {instance = "tilix"},
    properties = {
      maximized = false,
      placement = function(c)
        Utils.placement(c, "bottom")
      end,
      width = Utils.width_factor(1),
      height = Utils.height_factor(0.5),
      skip_taskbar = true,
      x_dropdown_utils = true,
      x_commands = true,
    }
  },
  -- Other Rules
  {
    rule = {instance = "Alacritty"},
    properties = {
      maximized = false,
      placement = function(c)
        Utils.placement(c, "centered")
      end,
      width = Utils.width_factor(0.7),
      height = Utils.height_factor(0.7),
      x_commands = true,
    }
  },
}

function Rules.check_title(c, force)
  if force == nil then
    force = false
  end

  -- c.maximized should be before awful.placement calls

  if Utils.startswith(c.name, "[ff_tile1]") then
    if not c.x_rules_applied or force then
      c.x_rules_applied = true
      c.x_frame = "top_left"
    end
  elseif Utils.startswith(c.name, "[ff_tile2]") then
    if not c.x_rules_applied or force then
      c.x_rules_applied = true
      c.x_frame = "top_right"
    end
  elseif Utils.startswith(c.name, "[ff_tile3]") then
    if not c.x_rules_applied or force then
      c.x_rules_applied = true
      c.x_frame = "bottom_right"
    end
  elseif Utils.startswith(c.name, "[chatgpt]") then
    if not c.x_rules_applied or force then
      c.x_rules_applied = true
      c.maximized = true
      c.width = Utils.width_factor(1)
      c.height = Utils.height_factor(1)
      c.skip_taskbar = true
      c.x_dropdown_gpt = true
    end
  end
end

function Rules.reset(c)
  awful.rules.apply(c)
  Rules.check_title(c, true)
  Frames.apply_rules(c, 1)
  c.x_focus_date = Utils.nano()
end

function Rules.apply(c)
  awful.rules.apply(c)
end
