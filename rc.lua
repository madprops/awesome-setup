local awful = require("awful")
local gears = require("gears")
awful.util.shell = "dash"

require("awful.autofocus")
require("modules/notifications")
require("modules/globals")
require("modules/utils")
require("modules/dropdowns")
require("modules/frames")
require("modules/bindings")
require("modules/theme")
require("modules/screens")
require("modules/clients")
require("modules/rules")
require("modules/menupanels")
require("modules/autostart")

local timer = gears.timer({
	timeout = 2,
	call_now = false,
	autostart = true,
	single_shot = true,
	callback = function()
		Frames.start()
		Dropdowns.hide_all()
	end,
})
