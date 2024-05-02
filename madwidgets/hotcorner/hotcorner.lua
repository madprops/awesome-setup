local awful = require("awful")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")
local hotcorner = {}

function hotcorner.create(args)
	local instance = {}

	args.text = "."
	args.opacity = 0
	local dot = multibutton.create(args).widget

	local x, y
	local size = 2

	if args.placement == "top_left" then
		x = args.screen.geometry.x
		y = args.screen.geometry.y
	elseif args.placement == "top_right" then
		x = args.screen.geometry.x + (args.screen.geometry.width - size)
		y = args.screen.geometry.y
	end

	instance.widget = wibox({
		x = x,
		y = y,
		visible = true,
		screen = args.screen,
		ontop = true,
		height = size,
		width = size,
		type = "utility",
		widget = dot,
	})

	return instance
end

return hotcorner
