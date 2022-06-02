local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("madwidgets/utils")

local sysmonitor = {}
local loading = "---"

function sysmonitor.update_string(instance, s, u)
  local new_text = ""

  if instance.args.mode == "cpu" then
   new_text = sysmonitor.cpustring(s)
  elseif instance.args.mode == "ram" then
   new_text = sysmonitor.ramstring(s)
  elseif instance.args.mode == "tmp" then
   new_text = sysmonitor.tmpstring(s)
  elseif instance.args.mode == "net_download" then
    new_text = sysmonitor.net_download_string(s, u)
  elseif instance.args.mode == "net_upload" then
   new_text = sysmonitor.net_upload_string(s, u)
  end

  if instance.current_text ~= new_text then
    instance.textbox_widget.text = new_text
    instance.current_text = new_text
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

function sysmonitor.net_download_string(s, u)
  u = u or "?"
  return "DW:"..s..u
end

function sysmonitor.net_upload_string(s, u)
  u = u or "?"
  return "UP:"..s..u
end

function sysmonitor.check_alert(instance, n)
  if n >= instance.args.alert_max then
    if instance.args.current_color ~= instance.args.alertcolor then
      instance.widget.fg = instance.args.alertcolor
      instance.args.current_color = instance.args.alertcolor
    end
  else
    if instance.args.current_color ~= instance.args.fontcolor then
      instance.widget.fg = instance.args.fontcolor
      instance.args.current_color = instance.args.fontcolor
    end
  end
end

function sysmonitor.default_string(instance)
  sysmonitor.update_string(instance, "---")
end

function sysmonitor.calc_net(instance)
  local cmd = "ip route show default | awk '/default/ {print $5}'"

  awful.spawn.easy_async_with_shell(cmd, function(dev)
    dev = trim(dev)
    
    if not dev or dev == "" then
      sysmonitor.default_string(instance)
      instance.timer:again()
      return
    end

    local cmd2 = string.format(instance.args.command, dev)

    awful.spawn.easy_async_with_shell(cmd2.."; sleep 1", function(o)
      if not utils.isnumber(o) then
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end
  
      awful.spawn.easy_async_with_shell(cmd2, function(o2)
        if not utils.isnumber(o2) then
          sysmonitor.default_string(instance)
          instance.timer:again()
          return
        end
        
        local diff = tonumber(o2) - tonumber(o)
        local mb = diff / 125000
        local v = mb
        local u = "M"
      
        if mb < 1 then
          v = diff / 125
          u = "K"
        end
      
        sysmonitor.check_alert(instance, mb)
        sysmonitor.update_string(instance, utils.numpad(v), u)
        instance.timer:again()
      end)
    end)
  end)
end

function sysmonitor.update(instance)
  if instance.args.mode == "cpu" or instance.args.mode == "ram" or instance.args.mode == "tmp" then
    awful.spawn.easy_async_with_shell(instance.args.command, function(o)
      if not utils.isnumber(o) then
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end

      sysmonitor.check_alert(instance, tonumber(o))
      sysmonitor.update_string(instance, utils.numpad(o))
      instance.timer:again()
    end)
  elseif instance.args.mode == "net_download" or instance.args.mode == "net_upload" then
    sysmonitor.calc_net(instance)
  end
end

function sysmonitor.create(args)
  args = args or {}
  args.bgcolor = args.bgcolor or beautiful.bg_normal
  args.fontcolor = args.fontcolor or beautiful.fg_normal
  args.alertcolor = args.alertcolor or "#E2242C"
  args.current_color = ""
  args.current_text = ""

  if args.mode == "cpu" then
    args.timeout = args.timeout or 3
    args.alert_max = args.alert_max or 70
    args.command = args.command or "mpstat 1 2 | awk 'END{print 100-$NF}'"
  elseif args.mode == "ram" then
    args.timeout = args.timeout or 3
    args.alert_max = args.alert_max or 70
    args.command = args.command or "free | grep Mem | awk '{print $3/$2 * 100.0}'"
  elseif args.mode == "tmp" then
    args.timeout = args.timeout or 3
    args.alert_max = args.alert_max or 70
    args.command = args.command or "sensors | grep Tctl: | awk '{print $2}' | sed 's/[^0-9.]*//g'"
  elseif args.mode == "net_download" then
    args.timeout = args.timeout or 1
    args.alert_max = args.alert_max or 10
    args.command = args.command or "cat /sys/class/net/%s/statistics/rx_bytes"
  elseif args.mode == "net_upload" then
    args.timeout = args.timeout or 1
    args.alert_max = args.alert_max or 10
    args.command = args.command or "cat /sys/class/net/%s/statistics/tx_bytes"
  end

  local instance = {}
  instance.args = args

  instance.textbox_widget = wibox.widget {
    markup = "---:---%",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  instance.widget = wibox.widget {
    instance.textbox_widget,
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg = args.fontcolor
  }

  instance.timer = gears.timer {
    timeout = args.timeout,
    call_now = false,
    autostart = true,
    single_shot = true,
    callback = function() sysmonitor.update(instance) end
  }

  return instance
end

return sysmonitor