local gears = require("gears")
local lockdelay = {}

function lockdelay.create(args)
  local lock = {}
  local locked = false
  args.delay = args.delay or 0
  args.action = args.action or function() end
  local d = args.delay / 1000

  function lock.trigger(arg)
    if locked then return
    else
      locked = true
      args.action(arg)
      gears.timer.start_new(d, function()
        locked = false
        return false
      end)
    end
  end

  return lock
end  

return lockdelay