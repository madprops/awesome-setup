local wibox = require("wibox")

local multibutton = {}

function multibutton.create(args)
  args = args or {}
  args.on_click = args.on_click or function() end
  args.on_middle_click = args.on_middle_click or function() end
  args.on_right_click = args.on_right_click or function() end
  args.on_wheel_up = args.on_wheel_up or function() end
  args.on_wheel_down = args.on_wheel_down or function() end
  args.on_mouse_enter = args.on_mouse_enter or function() end
  args.on_mouse_leave = args.on_mouse_leave or function() end

  local instance = {}
  instance.args = args

  if args.widget then
    instance.widget = args.widget
  elseif args.text then
    instance.textbox_widget = wibox.widget {
      align  = "center",
      valign = "center",
      text = args.text,
      widget = wibox.widget.textbox
    }

    if args.bgcolor and args.fontcolor then
      instance.widget = wibox.widget {
        instance.textbox_widget,
        widget = wibox.container.background,
        bg = args.bgcolor,
        fg = args.fontcolor
      }
    else
      instance.widget = instance.textbox_widget
    end
  
  else
    return {}
  end
  
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