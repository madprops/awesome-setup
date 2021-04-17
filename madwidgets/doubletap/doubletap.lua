local awful = require("awful")
local gears = require("gears")

local doubletap = {}

function doubletap.create(args)
  local tap = {}
  local last_tap = 0
  local locked = false
  
  if args.delay == nil then
    args.delay = 300
  end
  
  if args.lockdelay == nil then
    args.lockdelay = 0
  end

  if args.action == nil then
    args.action = function() end
  end

  local locktimer = gears.timer {
    timeout = args.lockdelay / 1000
  }

  locktimer:connect_signal("timeout", function()
    locked = false
    last_tap = 0
    locktimer:stop()
  end)

  function tap.trigger()
    if locked then return end
    
    awful.spawn.easy_async("date +%s%3N", function(output)
      local now = tonumber(output)
      if (now - last_tap < args.delay) then
        args.action()
        locked = true
        locktimer:start()
      else
        last_tap = now
      end
    end)
  end

  return tap
end

return doubletap