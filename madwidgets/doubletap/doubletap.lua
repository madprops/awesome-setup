local gears = require("gears")
local lockdelay = require("madwidgets/lockdelay/lockdelay")

local doubletap = {}

function doubletap.create(args)
	args = args or {}
	local tap = {}
	args.delay = args.delay or 300
	args.lockdelay = args.lockdelay or 0
	args.action = args.action or function() end

	local taptimer = gears.timer({
		timeout = args.delay / 1000,
	})

	taptimer:connect_signal("timeout", function()
		taptimer:stop()
	end)

	tap.lockdelay = lockdelay.create({ action = args.action, delay = args.lockdelay })

	function tap.trigger()
		if taptimer.started then
			tap.lockdelay.trigger()
		else
			taptimer:start()
		end
	end

	return tap
end

return doubletap
