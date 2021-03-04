local awful = require("awful")

local doubletap = {}

function doubletap.create(args)
  local tap = {}
  local last_tap = 0

  function tap.trigger()
    awful.spawn.easy_async("date +%s%3N", function(output)
      local now = tonumber(output)
      if (now - last_tap < args.delay) then
        args.action()
        last_tap = 0
      else
        last_tap = now
      end
    end)
  end

  return tap
end

return doubletap