local awful = require("awful")
local wibox = require("wibox")

local hotcorner = {}

function do_create(args, s)
  local corner = awful.popup({
    placement = args.placement,
    ontop = true,
    visible = true,
    border_width = 0,
    minimum_height = 2,
    minimum_width = 2,
    maximum_width = 2,
    maximum_height = 2,
    widget = wibox.widget.background,
    bg = "transparent",
    screen = s
  })
    
  corner:connect_signal("mouse::enter", function(btn)
    if args.action ~= nil then
      args.action()
    end
  end)
end

function hotcorner.create(args)
  awful.screen.connect_for_each_screen(function(s)
    do_create(args, s)
  end)
end

return hotcorner