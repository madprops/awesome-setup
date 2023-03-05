local gears = require("gears")
local debouncer = {}

function debouncer.create(args)
  args = args or {}
  local instance = {}
  local started = false
  args.delay = args.delay or 0
  args.action = args.action or function() end
  local d = args.delay / 1000

  function instance.trigger(arg)
    if started then
      return
    end
    
    started = true

    gears.timer.start_new(d, function()
      started = false
      args.action(arg)
    end)   
  end

  return instance
end  

return debouncer