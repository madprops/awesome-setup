local wibox = require("wibox")

local multibutton = {}

function multibutton.create(args)
  local button = wibox.widget {
    text = " "..args.text.." ",
    widget = wibox.widget.textbox,
  }
  
  button:connect_signal("button::press", function(a, b, c, btn, mods)
    if btn == 1 then
      if args.on_click ~= nil then
        args.on_click(button)
      end
    elseif btn == 2 then
      if args.on_middle_click ~= nil then
        args.on_middle_click(button)
      end
    elseif btn == 3 then
      if args.on_right_click ~= nil then
        args.on_right_click(button)
      end
    elseif btn == 4 then
      if args.on_wheel_up ~= nil then
        args.on_wheel_up(button)
      end      
    elseif btn == 5 then
      if args.on_wheel_down ~= nil then
        args.on_wheel_down(button)
      end
    end
  end)
  
  button:connect_signal("mouse::enter", function()
    if args.on_mouse_enter ~= nil then
      args.on_mouse_enter(button)
    end
  end)

  button:connect_signal("mouse::leave", function()
    if args.on_mouse_leave ~= nil then
      args.on_mouse_leave(button)
    end
  end)

  return button
end

return multibutton