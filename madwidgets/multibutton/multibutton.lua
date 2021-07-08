local wibox = require("wibox")
local utils = require("madwidgets/utils")

local multibutton = {}

function multibutton.create(args)
  args.text = args.text or "#"
  utils.check_mouse_events(args)

  local instance = {}
  instance.args = args
  instance.widget = wibox.widget.textbox(args.text, false)
  
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

  return instance
end

return multibutton