local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")

local sysmonitor = {}
local loading = "---"

function sysmonitor.update_strings(s, instance)
  if instance.mode == "cpu" then
    instance.textbox_widget.text = sysmonitor.cpustring(s)
  elseif instance.mode == "ram" then
    instance.textbox_widget.text = sysmonitor.ramstring(s)
  elseif instance.mode == "tmp" then
    instance.textbox_widget.text = sysmonitor.tmpstring(s)
  elseif instance.mode == "net_download" then
    instance.textbox_widget.text = sysmonitor.net_download_string(s)
  elseif instance.mode == "net_upload" then
    instance.textbox_widget.text = sysmonitor.net_upload_string(s)
  end
end

function sysmonitor.cpustring(s)
  return "CPU:"..s.."%"
end

function sysmonitor.ramstring(s)
  return "RAM:"..s.."%"
end

function sysmonitor.tmpstring(s)
  return "TMP:"..s.."°"
end

function sysmonitor.net_download_string(s)
  return "DOWN:"..s.."M"
end

function sysmonitor.net_upload_string(s)
  return "UP:"..s.."M"
end

function sysmonitor.update(instance)
  if instance.mode == "cpu" then
    local cmd = "mpstat 1 2 | awk 'END{print 100-$NF}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "cpu" then return end
      sysmonitor.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  elseif instance.mode == "ram" then
    local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "ram" then return end
      sysmonitor.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  elseif instance.mode == "tmp" then
    local cmd = "sensors | grep Tctl: | awk '{print $2}' | sed 's/[^0-9.]*//g'"
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "tmp" then return end
      sysmonitor.update_strings(utils.numpad(o), instance)
      instance.timer:again()
    end)
  elseif instance.mode == "net_download" then
    local cmd = string.format("cat /sys/class/net/%s/statistics/rx_bytes", instance.args.net_interface)

    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "net_download" then return end
      
      if instance.net_rx == -1 then
        instance.net_rx = tonumber(o)
      else
        local diff = (tonumber(o) - instance.net_rx) / 125000
        instance.net_rx = tonumber(o)
        sysmonitor.update_strings(utils.numpad(diff), instance)
      end

      instance.timer:again()
    end)
  elseif instance.mode == "net_upload" then
    local cmd = string.format("cat /sys/class/net/%s/statistics/tx_bytes", instance.args.net_interface)

    awful.spawn.easy_async_with_shell(cmd, function(o)
      if instance.mode ~= "net_upload" then return end
      
      if instance.net_tx == -1 then
        instance.net_tx = tonumber(o)
      else
        local diff = (tonumber(o) - instance.net_tx) / 125000
        instance.net_tx = tonumber(o)
        sysmonitor.update_strings(utils.numpad(diff), instance)
      end

      instance.timer:again()
    end)
  end
end

function sysmonitor.create(args)
  args = args or {}
  args.bgcolor = args.bgcolor or "#2B303B"
  args.fontcolor = args.fontcolor or "#b8babc"

  local instance = {}
  instance.args = args
  instance.mode = args.mode or "cpu"
  instance.net_rx = -1
  instance.net_tx = -1

  instance.textbox_widget = wibox.widget {
    markup = "---:---%",
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

  instance.timer = gears.timer {
    timeout = 3,
    call_now = false,
    autostart = true,
    single_shot = true,
    callback = function() sysmonitor.update(instance) end
  }

  return instance
end

return sysmonitor