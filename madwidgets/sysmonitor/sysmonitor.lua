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

  elseif mode == "gpu" then
    t = "GPU"
    u = "%"

  elseif mode == "gpu_ram" then
    t = "GPU RAM"
    u = "%"

  elseif mode == "net_download" then
    t = "DW"

  elseif mode == "net_upload" then
    t = "UP"

  else
    return
  end

  u = u or "?"

  local new_text = t .. ":" .. s .. u

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

-- NEW: Stateful CPU calculation reading /proc/stat
function sysmonitor.calc_cpu(instance)
  -- We use cat instead of pure lua io to keep it async and non-blocking for the WM
  awful.spawn.easy_async_with_shell("cat /proc/stat | grep '^cpu '", function(out)
    out = utils.trim(out)

    -- Parse the first line of /proc/stat
    -- user, nice, system, idle, iowait, irq, softirq, steal
    local user, nice, system, idle, iowait, irq, softirq, steal =
      out:match("cpu%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)%s+(%d+)")

    if not user then
      sysmonitor.on_null(instance)
      return
    end

    local total = user + nice + system + idle + iowait + irq + softirq + steal
    local idle_sum = idle + iowait

    local diff_total = total - instance.cpu_prev_total
    local diff_idle = idle_sum - instance.cpu_prev_idle

    -- Save current state for next run
    instance.cpu_prev_total = total
    instance.cpu_prev_idle = idle_sum

    -- Avoid division by zero on very fast updates
    if diff_total == 0 then
      instance.timer:again()
      return
    end

    local usage = (diff_total - diff_idle) / diff_total * 100

    sysmonitor.check_alert(instance, usage)
    sysmonitor.update_string(instance, utils.numpad(usage, 3))
    instance.timer:again()
  end)
end

function sysmonitor.calc_net(instance)
  local cmd = "ip route show default | awk '/default/ {print $5; exit}'"

  awful.spawn.easy_async_with_shell(cmd, function(dev)
    dev = utils.trim(dev)

    if not dev or dev == "" then
      sysmonitor.on_null(instance)
      return
    end

    local cmd2 = string.format(instance.args.command, dev)

    awful.spawn.easy_async_with_shell(cmd2 .. "; sleep 1", function(o)
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
        sysmonitor.update_string(instance, utils.numpad(v, 3), u)
        instance.timer:again()
      end)
    end)
  end)
end

function sysmonitor.calc_gpu(instance)
  local cmd = "/opt/rocm/bin/rocm-smi --showtemp --showuse --showmemuse --json | jq '.card0' |"
  local gpu = " jq '.\"GPU use (%)\"'"
  local ram = " jq '.\"GPU Memory Allocated (VRAM%)\"'"

  if instance.args.mode == "gpu_ram" then
    cmd = cmd .. ram

  else
    cmd = cmd .. gpu
  end

  awful.spawn.easy_async_with_shell(cmd, function(o)
    o = utils.trim(o)
    o = utils.remove_quotes(o)

    if not utils.isnumber(o) then
      sysmonitor.on_null(instance)
      return
    end

    sysmonitor.check_alert(instance, tonumber(o))
    sysmonitor.update_string(instance, utils.numpad(o, 3), "%")
    instance.timer:again()
  end)
end

function sysmonitor.update(instance)
  if instance.args.mode == "cpu" then
    sysmonitor.calc_cpu(instance)

  elseif instance.args.mode == "ram" or instance.args.mode == "tmp" then
    awful.spawn.easy_async_with_shell(instance.args.command, function(o)
      if not utils.isnumber(o) then
        sysmonitor.on_null(instance)
        return
      end

      sysmonitor.check_alert(instance, tonumber(o))
      sysmonitor.update_string(instance, utils.numpad(o, 3))
      instance.timer:again()
    end)

  elseif instance.args.mode == "net_download" or instance.args.mode == "net_upload" then
    sysmonitor.calc_net(instance)

  elseif instance.args.mode == "gpu" or instance.args.mode == "gpu_ram" then
    sysmonitor.calc_gpu(instance)
  end
end

function sysmonitor.create(args)
  args = args or {}
  args.alertcolor = args.alertcolor or "#E2242C"
  args.timeout = args.timeout or 3

  if args.mode == "cpu" then
    args.alert_max = args.alert_max or 70
    -- Command removed, using calc_cpu logic

  elseif args.mode == "ram" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or "free | grep Mem | awk '{print $3/$2 * 100.0}'"

  elseif args.mode == "gpu" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or ""

  elseif args.mode == "gpu_ram" then
    args.alert_max = args.alert_max or 70
    args.command = args.command or ""

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

  -- Initial values for CPU calculation
  instance.cpu_prev_total = 0
  instance.cpu_prev_idle = 0

  instance.text_widget = wibox.widget({
    markup = "---:---%",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  })

  args.widget = instance.text_widget
  instance.widget = multibutton.create(args).widget

  instance.timer = gears.timer({
    timeout = args.timeout,
    call_now = false,
    autostart = true,
    single_shot = true,
    callback = function()
      sysmonitor.update(instance)
    end,
  })

  return instance
end

return sysmonitor