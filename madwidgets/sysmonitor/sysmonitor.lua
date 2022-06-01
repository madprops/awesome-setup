local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")

local sysmonitor = {}
local loading = "---"

function sysmonitor.update_string(instance, s, u)
  local new_text = ""

  if instance.mode == "cpu" then
   new_text = sysmonitor.cpustring(s)
  elseif instance.mode == "ram" then
   new_text = sysmonitor.ramstring(s)
  elseif instance.mode == "tmp" then
   new_text = sysmonitor.tmpstring(s)
  elseif instance.mode == "net_download" then
    new_text = sysmonitor.net_download_string(s, u)
  elseif instance.mode == "net_upload" then
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
  local unit = u or "K"
  return "DW:"..s..unit
end

function sysmonitor.net_upload_string(s, u)
  local unit = u or "K"
  return "UP:"..s..unit
end

function sysmonitor.calc_net(instance, o, loadtype)
  local diff = tonumber(o) - loadtype
  local mb = diff / 125000
  local v = mb
  local u = "M"

  if mb < 1 then
    v = diff / 125
    u = "K"
  end

  sysmonitor.check_alert(instance, mb)
  sysmonitor.update_string(instance, utils.numpad(v), u)
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

function sysmonitor.update(instance)
  if instance.mode == "cpu" then
    local cmd = "mpstat 1 2 | awk 'END{print 100-$NF}'"
    
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if not utils.isnumber(o) then
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end

      sysmonitor.check_alert(instance, tonumber(o))
      sysmonitor.update_string(instance, utils.numpad(o))
      instance.timer:again()
    end)
  elseif instance.mode == "ram" then
    local cmd = "free | grep Mem | awk '{print $3/$2 * 100.0}'"
    
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if not utils.isnumber(o) then
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end

      sysmonitor.check_alert(instance, tonumber(o))
      sysmonitor.update_string(instance, utils.numpad(o))
      instance.timer:again()
    end)
  elseif instance.mode == "tmp" then
    local cmd = "sensors | grep Tctl: | awk '{print $2}' | sed 's/[^0-9.]*//g'"
    
    awful.spawn.easy_async_with_shell(cmd, function(o)
      if not utils.isnumber(o) then
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end

      sysmonitor.check_alert(instance, tonumber(o))
      sysmonitor.update_string(instance, utils.numpad(o))
      instance.timer:again()
    end)
  elseif instance.mode == "net_download" then
    local cmd = string.format("cat /sys/class/net/%s/statistics/rx_bytes", instance.args.net_interface)

    awful.spawn.easy_async_with_shell(cmd, function(o)
      if not utils.isnumber(o) then
        instance.net_rx = -1
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end
      
      if instance.net_rx == -1 then
        instance.net_rx = tonumber(o)
      else
        sysmonitor.calc_net(instance, o, instance.net_rx)
        instance.net_rx = tonumber(o)
      end

      instance.timer:again()
    end)
  elseif instance.mode == "net_upload" then
    local cmd = string.format("cat /sys/class/net/%s/statistics/tx_bytes", instance.args.net_interface)

    awful.spawn.easy_async_with_shell(cmd, function(o)
      if not utils.isnumber(o) then
        instance.net_tx = -1
        sysmonitor.default_string(instance)
        instance.timer:again()
        return
      end
      
      if instance.net_tx == -1 then
        instance.net_tx = tonumber(o)
      else
        sysmonitor.calc_net(instance, o, instance.net_tx)
        instance.net_tx = tonumber(o)
      end

      instance.timer:again()
    end)
  end
end

function sysmonitor.create(args)
  args = args or {}
  args.bgcolor = args.bgcolor or "#2B303B"
  args.fontcolor = args.fontcolor or "#B8BABC"
  args.alertcolor = args.alertcolor or "#E2242C"
  args.current_color = ""
  args.current_text = ""

  if args.mode == "cpu" then
    args.alert_max = args.alert_max or 70
  elseif args.mode == "ram" then
    args.alert_max = args.alert_max or 70
  elseif args.mode == "tmp" then
    args.alert_max = args.alert_max or 70
  elseif args.mode == "net_download" then
    args.alert_max = args.alert_max or 10
  elseif args.mode == "net_upload" then
    args.alert_max = args.alert_max or 10
  end

  local instance = {}
  instance.args = args
  instance.mode = args.mode or "cpu"
  instance.net_rx = -1
  instance.net_tx = -1

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

  local timeout = 3

  if instance.mode == "net_download" or instance.mode == "net_upload" then
    timeout = 1
  end

  instance.timer = gears.timer {
    timeout = timeout,
    call_now = false,
    autostart = true,
    single_shot = true,
    callback = function() sysmonitor.update(instance) end
  }

  return instance
end

return sysmonitor