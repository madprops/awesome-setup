local awful = require("awful")
local wibox = require("wibox")
local utils = require("madwidgets/utils")

local volumecontrol = {}
volumecontrol.max_volume = 100
volumecontrol.steps = 5

local instances = {}
local last_volume = 100
local loading = "---"

function volumecontrol.update_volume(vol)
  for i, instance in ipairs(instances) do
    instance.textbox_widget.text = " "..volumecontrol.volstring(utils.numpad(vol)).." "
  end
end

function volumecontrol.get_volume(f)
  awful.spawn.easy_async_with_shell('pulsemixer --get-volume | grep -o "^\\w*\\b"', function(vol)
    f(tonumber(vol))
  end)
end

function volumecontrol.change_volume(vol)
  awful.util.spawn_with_shell("pactl set-sink-volume @DEFAULT_SINK@ "..vol.."%", false) 
  volumecontrol.update_volume(vol)
end

function volumecontrol.set(vol)
  vol = tonumber(vol)
  if vol > volumecontrol.max_volume or vol < 0 then
    return
  end
  volumecontrol.change_volume(vol)
end

function volumecontrol.increase()
  volumecontrol.get_volume(function(vol)
    if vol < volumecontrol.max_volume then
      vol = vol + volumecontrol.steps
      if vol > volumecontrol.max_volume then
        vol = volumecontrol.max_volume
      end
      volumecontrol.change_volume(vol)
    end
  end)
end

function volumecontrol.decrease()
  volumecontrol.get_volume(function(vol)
    if vol > 0 then
      vol = vol - volumecontrol.steps
      if vol < 0 then
        vol = 0
      end
      volumecontrol.change_volume(vol)
    end
  end)
end

function volumecontrol.max()
  volumecontrol.change_volume(volumecontrol.max_volume)
end

function volumecontrol.mute()
  volumecontrol.get_volume(function(vol)
    if vol == 0 then
      volumecontrol.set(last_volume)
    else
      last_volume = vol
      volumecontrol.set(0)
    end
  end)
end

function volumecontrol.refresh()
  volumecontrol.get_volume(function(vol)
    volumecontrol.update_volume(vol)
  end)
end

function volumecontrol.volstring(s)
  return "VOL:"..s.."%"
end

function volumecontrol.create(args)
  args = args or {}

  local instance = {}
  instance.args = args
  args.bgcolor = args.bgcolor or "#333B4B"
  args.fontcolor = args.fontcolor or "#b8babc"

  instance.textbox_widget = wibox.widget {
    markup = volumecontrol.volstring(loading),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  instance.widget = wibox.widget {
    instance.textbox_widget,
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg = args.fontcolor
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