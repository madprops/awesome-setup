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
    bg = "red",
    opacity = 0
  })
    
  corner:connect_signal("mouse::enter", function()
    if args.action ~= nil then
      args.action(corner)
    end
  end)

  corner:connect_signal("mouse::leave", function()
    if args.action_2 ~= nil then
      args.action_2(corner)
    end
  end)
end

return hotcorner