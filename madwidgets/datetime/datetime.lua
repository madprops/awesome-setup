local awful = require("awful")
local wibox = require("wibox")

local datetime = {}

function datetime.create(args)
  local instance = awful.widget.textclock("%a %b %d %l:%M %P", 15)

  instance:connect_signal("button::press", function(a, b, c, button, mods)
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

  awful.tooltip {
    objects = { instance },
    timer_function = function()
      local text = ""
      text = text..os.date('%T\n%A %B %d %Y')
      return text
    end
  }  

  return instance
end

return datetime