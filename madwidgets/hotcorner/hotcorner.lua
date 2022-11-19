local awful = require("awful")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")
local hotcorner = {}

function hotcorner.create(args)
  local instance = {}

  args.text = "."
  local square = multibutton.create(args).widget

  instance.widget = awful.popup({
    screen = args.screen,
    placement = args.placement,
    ontop = true,
    visible = true,
    widget = square
  })

  return instance
end

return hotcorner