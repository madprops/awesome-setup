local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local utils = require("madwidgets/utils")
local multibutton = require("madwidgets/multibutton/multibutton")

local sysmonitor = {}

function sysmonitor.update_string(instance, s, u)
  local t = ""
  local mode = instance.args.mode

  if mode == "cpu" then
    t = "CPU"
    u = "%"
  elseif mode == "ram" then
    t = "RAM"
    u = "%"
  elseif mode == "tmp" then
    t = "TMP"
    u = "°"
  elseif mode == "net_download" then
    t = "DW"
  elseif mode == "net_upload" then
    t = "UP"
  else
    return
  end

  u = u or "?" 

  local new_text = t..":"..s..u

  if instance.current_text ~= new_text then
    instance.text_widget.text = new_text
    instance.current_text = new_text
  end
end

function sysmonitor.check_alert(instance, n)
  if n >= instance.args.alert_max then
    if instance.current_color ~= instance.args.alertcolor then
      instance.widget.fg = instance.args.alertcolor
      instance.current_color = instance.args.alertcolor
    end
  else
    if instance.current_color ~= instance.args.fontcolor then
      instance.widget.fg = instance.args.fontcolor
      instance.current_color = instance.args.fontcolor
    end
  end
end

function sysmonitor.default_string(instance)
  sysmonitor.update_string(instance, "---")
end

function sysmonitor.on_null(instance)
  sysmonitor.default_string(instance)
  sysmonitor.check_alert(instance, 0)
  instance.timer:again()
end

function sysmonitor.calc_net(instance)
  local cmd = "ip route show default | awk '/default/ {print $5}'"

  awful.spawn.easy_async_with_shell(cmd, function(dev)
    dev = trim(dev)

    if not dev or dev == "" then
      sysmonitor.on_null(instance)
      return
    end

    local cmd2 = string.format(instance.args.command, dev)

    awful.spawn.easy_async_with_shell(cmd2.."; sleep 1", function(o)
      if not utils.isnumber(o) then
        sysmonitor.on_null(instance)
        return
      end
  
      awful.spawn.easy_async_with_shell(cmd2, function(o2)
        if not utils.isnumber(o2) then
          sysmonitor.on_null(instance)
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
        sysmonitor.on_null(instnace)
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
  args.alertcolor = args.alertcolor or "#E2242C"
  args.timeout = args.timeout or 1

  if args.mode == "cpu" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or "mpstat 1 2 | awk 'END{print 100-$NF}'"
  elseif args.mode == "ram" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or "free | grep Mem | awk '{print $3/$2 * 100.0}'"
  elseif args.mode == "tmp" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or "sensors | grep Tctl: | awk '{print $2}' | sed 's/[^0-9.]*//g'"
  elseif args.mode == "net_download" then
    args.alert_max = args.alert_max or 10
    args.command = args.command or "cat /sys/class/net/%s/statistics/rx_bytes"
  elseif args.mode == "net_upload" then
    args.alert_max = args.alert_max or 10
    args.command = args.command or "cat /sys/class/net/%s/statistics/tx_bytes"
  end

  local instance = {}
  instance.args = args
  instance.current_color = ""
  instance.current_text = ""

  instance.text_widget = wibox.widget {
    markup = "---:---%",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  args.widget = instance.text_widget
  instance.widget = multibutton.create(args).widget

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