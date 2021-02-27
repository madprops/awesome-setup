local awful = require("awful")
local wibox = require("wibox")

local hotcorner = {}

function hotcorner.create(args)
  local corner = awful.popup({
    screen = args.screen,
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
  })
    
  corner:connect_signal("mouse::enter", function(btn)
    if args.action ~= nil then
      args.action()
    end
  end)
end

return hotcorner