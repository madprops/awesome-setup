local awful = require("awful")
local wibox = require("wibox")
local utils = require("madwidgets/utils")

local volumecontrol = {}
volumecontrol.max_volume = 100
volumecontrol.steps = 5

local instances = {}
local last_volume = 100

function update_volume(vol)
  for i, instance in ipairs(instances) do
    instance.widget.text = volstring(utils.numpad(vol), instance)
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
  change_volume(volumecontrol.max_volume)
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

function volumecontrol.refresh()
  get_volume(function(vol)
    update_volume(vol)
  end)
end

function volstring(s, instance)
  return instance.args.text_left.."Vol: "..s.."%"..instance.args.text_right
end

function volumecontrol.create(args)
  args.text_left = args.text_left or ""
  args.text_right = args.text_right or ""

  local instance = {}
  instance.args = args

  instance.widget = wibox.widget {
    markup = volstring("100", instance),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
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
  return instance
end

return volumecontrol