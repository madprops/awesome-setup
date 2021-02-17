local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")

local volumecontrol = {}
volumecontrol.max_volume = 115
volumecontrol.steps = 5

local update_timeout
local instances = {}
local last_volume = 100

function msg(txt)
  naughty.notify({text = " "..txt.." "})
end

function volumecontrol.change(mode)
  volumecontrol.get(function(vol)
    if type(mode) == "number" then
      vol = mode
    else
      if mode == "increase" then
        if vol < volumecontrol.max_volume then
          vol = vol + volumecontrol.steps
          if vol > volumecontrol.max_volume then
            vol = volumecontrol.max_volume
          end
        end
      elseif mode == "decrease" then
        if vol > 0 then
          vol = vol - volumecontrol.steps
          if vol < 0 then
            vol = 0
          end
        end
      end
    end
    awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..vol.."%", false) 
    volumecontrol.update(vol)
  end)
end

function volumecontrol.max()
  volumecontrol.get(function(vol)
    local newvol = 0

    if vol == 100 then
      newvol = volumecontrol.max_volume
    else
      newvol = 100
    end

    awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..newvol.."%", false)
    volumecontrol.update(newvol)
  end)
end

function volumecontrol.mute()
  volumecontrol.get(function(vol)
    if vol == 0 then
      volumecontrol.change(last_volume)
    else
      last_volume = vol
      volumecontrol.change(0)
    end
  end)
end

function volumecontrol.update(vol)
  local svol = vol

  if vol < 100 then
    svol = "0"..vol
  end

  if vol < 10 then
    svol = "0"..svol
  end

  for i, instance in ipairs(instances) do
    instance.text = "Vol: "..svol.."%"
  end
end

function volumecontrol.get(f)
  awful.spawn.easy_async_with_shell('pulsemixer --get-volume | grep -o "^\\w*\\b"', function(vol)
    f(tonumber(vol))
  end)
end

function volumecontrol.create(args)
  local instance = wibox.widget {
    markup = ' -- % ',
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  instance:connect_signal("button::press", function(a, b, c, button, mods)
      if button == 1 then
          volumecontrol.max()
      elseif button == 2 then
          volumecontrol.mute()
      elseif button == 4 then
        volumecontrol.change("increase")      
      elseif button == 5 then
          volumecontrol.change("decrease")
      end
  end)

  table.insert(instances, instance)

  if update_timeout == nil then
    update_timeout = gears.timer {
      timeout = 2,
      autostart = true,
      callback = function()
        volumecontrol.change("update")
      end
    }
  end

  return instance
end

return volumecontrol