local awful = require("awful")
local gears = require("gears")

local doubletap = {}

function doubletap.create(args)
  local tap = {}
  local locked = false
  args.delay = args.delay or 300
  args.lockdelay = args.lockdelay or 0
  args.action = args.action or function() end

  local taptimer = gears.timer {
    timeout = args.delay / 1000
  }

  taptimer:connect_signal("timeout", function()
    taptimer:stop()
  end)

  local locktimer = gears.timer {
    timeout = args.lockdelay / 1000
  }

  locktimer:connect_signal("timeout", function()
    locked = false
    locktimer:stop()
  end)

  function tap.trigger()
    if locked then return end
    if taptimer.started then
      args.action()
      locked = true
      locktimer:start()
    else
      taptimer:start()
    end
  end

  return tap
end

return doubletap