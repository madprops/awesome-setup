local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local multibutton = require("madwidgets/multibutton/multibutton")

local cpu = {}
local instances = {}

function cpustring(s, instance)
  return instance.args.text_left.."CPU: "..s.."%"..instance.args.text_right
end

function update()
  if #instances < 1 then return end

  local cmd = "mpstat 1 3 | awk 'END{print 100-$NF}'"
  awful.spawn.easy_async_with_shell(cmd, function(avg)
    avg = tonumber(avg)
    if avg < 100 then
      savg = "0"..avg
    end
    if avg < 10 then
      savg = "0"..savg
    end
    for i, instance in ipairs(instances) do
      instance.widget.text = cpustring(savg, instance)
    end
  end)
end

function cpu.create(args)
  args.text_left = args.text_left or ""
  args.text_right = args.text_right or ""

  local instance = {}
  instance.args = args

  args.widget = wibox.widget {
    markup = cpustring("000", instance),
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  instance.widget = multibutton.create(args).widget

  table.insert(instances, instance)
  return instance
end

gears.timer.start_new(3, function()
  update()
  return true
end)

return cpu