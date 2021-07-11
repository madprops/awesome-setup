local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")

local cpu = {}
cpu.modes = {"cpu", "ram"}
cpu.mode = 1

local instances = {}

function cpu.update_strings(s)
  for i, instance in ipairs(instances) do
    if cpu.modes[cpu.mode] == "cpu" then
      instance.widget.text = cpu.cpustring(s, instance)
    elseif cpu.modes[cpu.mode] == "ram" then
      instance.widget.text = cpu.ramstring(s, instance)
    end
  end
end

function cpu.cpustring(s, instance)
  return instance.args.text_left.."CPU: "..s.."%"..instance.args.text_right
end

function cpu.ramstring(s, instance)
  return instance.args.text_left.."RAM: "..s.."%"..instance.args.text_right
end

function cpu.update()
  if #instances < 1 then return end

  if cpu.modes[cpu.mode] == "cpu" then
    local cmd = "mpstat 1 2 | awk 'END{print 100-$NF}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if cpu.modes[cpu.mode] ~= "cpu" then return end
      cpu.update_strings(utils.numpad(o))
      cpu.timer:again()
    end)
  elseif cpu.modes[cpu.mode] == "ram" then
    local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if cpu.modes[cpu.mode] ~= "ram" then return end
      cpu.update_strings(utils.numpad(o))
      cpu.timer:again()
    end)
  end
end

function cpu.cycle_mode()
  cpu.timer:stop()

  if cpu.mode < #cpu.modes then
    cpu.mode = cpu.mode + 1
  else
    cpu.mode = 1
  end

  cpu.update_strings("000")
  cpu.update()
end

function cpu.create(args)
  args.text_left = args.text_left or ""
  args.text_right = args.text_right or ""

  local instance = {}
  instance.args = args

  instance.widget = wibox.widget {
    markup = cpu.cpustring("000", instance),
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