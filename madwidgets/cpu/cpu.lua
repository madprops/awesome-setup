local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")
local lockdelay = require("madwidgets/lockdelay/lockdelay")

local cpu = {}
local modes = {"cpu", "ram", "tmp"}
local loading = "---"

local instances = {}

function cpu.update_strings(s, instance)
  if instance.mode == "cpu" then
    instance.widget.text = cpu.cpustring(s)
  elseif instance.mode == "ram" then
    instance.widget.text = cpu.ramstring(s)
  elseif instance.mode == "tmp" then
    instance.widget.text = cpu.tmpstring(s)
  end
end

function cpu.cpustring(s)
  return "CPU:"..s.."%"
end

function cpu.ramstring(s)
  return "RAM:"..s.."%"
end

function cpu.tmpstring(s)
  return "TMP:"..s.."°"
end

function cpu.update(instance)
  if instance.mode == "cpu" then
    local cmd = "mpstat 1 2 | awk 'END{print 100-$NF}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "cpu" then return end
      cpu.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  elseif instance.mode == "ram" then
    local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "ram" then return end
      cpu.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  elseif instance.mode == "tmp" then
    local cmd = "sensors | grep die | awk '{print $2}' | sed 's/[^0-9.]*//g'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "tmp" then return end
      cpu.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  end
end

function cpu.cycle_mode_dec(instance)
  local i = utils.indexof(instance.mode, modes)

  if i > 0 then
    instance.mode = modes[i - 1]
  else
    instance.mode = modes[#modes]
  end

  cpu.after_mode_change(instance)
end

function cpu.cycle_mode_inc(instance)
  local i = utils.indexof(instance.mode, modes)

  if i < #modes then
    instance.mode = modes[i + 1]
  else
    instance.mode = modes[1]
  end

  cpu.after_mode_change(instance)
end

function cpu.after_mode_change(instance)
  instance.timer:stop()
  cpu.update_strings(loading, instance)
  cpu.update(instance)
end

function cpu.create(args)
  args.default_mode = args.default_mode or 1
  
  if utils.indexof(args.default_mode, modes) == -1 then
    args.default_mode = "cpu"
  end

  args = args or {}
  args.on_click = args.on_click or function() end

  local instance = {}
  instance.args = args
  instance.mode = args.default_mode

  instance.widget = wibox.widget {
    markup = "---:---%",
    align  = 'center',
    valign = 'center',
    widget = wibox.widget.textbox
  }

  local cyclelock_dec = lockdelay.create({
    action = function()
      cpu.cycle_mode_dec(instance)
    end,
    delay = 250
  })

  local cyclelock_inc = lockdelay.create({
    action = function()
      cpu.cycle_mode_inc(instance)
    end,
    delay = 250
  })

  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then
      args.on_click()
    elseif button == 3 then
      instance.mode = args.default_mode
      cpu.after_mode_change(instance)
    elseif button == 4 then
      cyclelock_dec.trigger()
    elseif button == 5 then
      cyclelock_inc.trigger()
    end
  end)

  instance.timer = gears.timer {
    timeout = 3,
    call_now = false,
    autostart = true,
    single_shot = true,
    callback = function() cpu.update(instance) end
  }

  table.insert(instances, instance)
  return instance
end

return cpu