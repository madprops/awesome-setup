local gears = require("gears")
local lockdelay = {}

function lockdelay.create(args)
  local lock = {}
  local locked = false
  args.delay = args.delay or 300
  args.action = args.action or function() end

  local locktimer = gears.timer {
    timeout = args.delay / 1000
  }

  locktimer:connect_signal("timeout", function()
    locktimer:stop()
    locked = false
  end)

  function lock.trigger(arg)
    if locked then return
    else
      locked = true
      args.action(arg)
      locktimer:start()
    end
  end

  return lock
end  

return lockdelay