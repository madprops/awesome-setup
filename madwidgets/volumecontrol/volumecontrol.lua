local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local volumecontrol = {}
volumecontrol.max_volume = 115
volumecontrol.steps = 5

local update_timeout
local instances = {}
local last_volume = 100

function update_volume(vol)
  vol = tonumber(vol)
  local svol = vol

  if vol < 100 then
    svol = "0"..vol
  end

  if vol < 10 then
    svol = "0"..svol
  end

  for i, instance in ipairs(instances) do
    instance.text = volstring(svol)
  end
end

function get_volume(f)
  awful.spawn.easy_async_with_shell('pulsemixer --get-volume | grep -o "^\\w*\\b"', function(vol)
    f(tonumber(vol))
  end)
end

function change_volume(vol)
  awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..vol.."%", false) 
  update_volume(vol)
end

function volumecontrol.set(vol)
  vol = tonumber(vol)
  if vol > volumecontrol.max_volume or vol < 0 then
    return
  end
  change_volume(vol)
end

function volumecontrol.increase()
  get_volume(function(vol)
    if vol < volumecontrol.max_volume then
      vol = vol + volumecontrol.steps
      if vol > volumecontrol.max_volume then
        vol = volumecontrol.max_volume
      end
      change_volume(vol)
    end
  end)
end

function volumecontrol.decrease()
  get_volume(function(vol)
    if vol > 0 then
      vol = vol - volumecontrol.steps
      if vol < 0 then
        vol = 0
      end
      change_volume(vol)
    end
  end)
end

function volumecontrol.max()
  get_volume(function(vol)
    local newvol = 0

    if vol == 100 then
      newvol = volumecontrol.max_volume
    else
      newvol = 100
    end

    awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..newvol.."%", false)
    update_volume(newvol)
  end)
end

function volumecontrol.mute()
  get_volume(function(vol)
    if vol == 0 then
      volumecontrol.set(last_volume)
    else
      last_volume = vol
      volumecontrol.set(0)
    end
  end)
end

function volstring(s)
  return "Vol: "..s.."%"
end

function volumecontrol.create(args)
  local instance = wibox.widget {
    markup = volstring("100"),
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
      volumecontrol.increase()  
    elseif button == 5 then
      volumecontrol.decrease()
    end
  end)

  table.insert(instances, instance)

  if update_timeout == nil then
    update_timeout = gears.timer {
      timeout = 3,
      autostart = true,
      callback = function()
        get_volume(function(vol)
          update_volume(vol)
        end)
      end
    }
  end

  return instance
end

return volumecontrol