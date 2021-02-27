local wibox = require("wibox")

local multibutton = {}

function multibutton.create(args)
  local button = wibox.widget {
    text = " "..args.text.." ",
    widget = wibox.widget.textbox,
  }
  
  button:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then
      if args.on_click ~= nil then
        args.on_click()
      end
    elseif button == 2 then
      if args.on_middle_click ~= nil then
        args.on_middle_click()
      end
    elseif button == 3 then
      if args.on_right_click ~= nil then
        args.on_right_click()
      end
    elseif button == 4 then
      if args.on_wheel_up ~= nil then
        args.on_wheel_up()
      end      
    elseif button == 5 then
      if args.on_wheel_down ~= nil then
        args.on_wheel_down()
      end
    end
  end)   

  return button
end

return multibutton