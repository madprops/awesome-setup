local awful = require("awful")
local wibox = require("wibox")
local utils = require("madwidgets/utils")

local datetime = {}

function datetime.create(args)
  args.text_left = args.text_left or ""
  args.text_right = args.text_right or ""
  utils.check_mouse_events(args)

  local instance = {}
  instance.args = args
  instance.widget = awful.widget.textclock(args.text_left.."%a %d %b %l:%M %P"..args.text_right, 15)

  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then 
      args.on_click(instance)
    elseif button == 2 then 
      args.on_middle_click(instance)
    elseif button == 3 then 
      args.on_right_click(instance)
    elseif button == 4 then 
      args.on_wheel_up(instance)
    elseif button == 5 then 
      args.on_wheel_down(instance)
    end
  end)

  instance.widget:connect_signal("mouse::enter", function()
    args.on_mouse_enter(instance)
  end)

  instance.widget:connect_signal("mouse::leave", function()
    args.on_mouse_leave(instance)
  end)

  awful.tooltip {
    objects = { instance.widget },
    timer_function = function()
      local text = ""
      text = text..os.date('%T\n%A %B (%m) %d %Y')
      return text
    end
  }  

  return instance
end

return datetime