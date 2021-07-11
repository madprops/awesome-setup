local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")

local cpu = {}
local modes = {"cpu", "ram"}
local mode = 1
local loading = "---"

local instances = {}

function cpu.get_mode()
  return modes[mode]
end

function cpu.update_strings(s)
  for i, instance in ipairs(instances) do
    if cpu.get_mode() == "cpu" then
      instance.widget.text = cpu.cpustring(s)
    elseif cpu.get_mode() == "ram" then
      instance.widget.text = cpu.ramstring(s)
    end
  end
end

function cpu.cpustring(s)
  return "CPU:"..s.."%"
end

function cpu.ramstring(s)
  return "RAM:"..s.."%"
end

function cpu.update()
  if #instances < 1 then return end

  if cpu.get_mode() == "cpu" then
    local cmd = "mpstat 1 2 | awk 'END{print 100-$NF}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if cpu.get_mode() ~= "cpu" then return end
      cpu.update_strings(utils.numpad(o))
      cpu.timer:again()
    end)
  elseif cpu.get_mode() == "ram" then
    local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if cpu.get_mode() ~= "ram" then return end
      cpu.update_strings(utils.numpad(o))
      cpu.timer:again()
    end)
  end
end

function cpu.cycle_mode()
  cpu.timer:stop()

  if mode < #modes then
    mode = mode + 1
  else
    mode = 1
  end

  cpu.update_strings(loading)
  cpu.update()
end

function cpu.create(args)
  args = args or {}

  local instance = {}
  instance.args = args

  instance.widget = wibox.widget {
    markup = cpu.cpustring(loading),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then
      cpu.cycle_mode()
    end
  end)

  table.insert(instances, instance)
  return instance
end

cpu.timer = gears.timer {
  timeout = 3,
  call_now = false,
  autostart = true,
  single_shot = true,
  callback = function() cpu.update() end
}

return cpu