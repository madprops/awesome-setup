# sysmonitor

Show CPU, RAM, Temperature, or Net Download/Upload

![](https://i.imgur.com/NJTjgcW.jpg)

## To use it

Put this near the top:
>local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")

Then place it somewhere in the panel:

```
sysmonitor.create({
  mode = "cpu"
})
```

Available modes:

- cpu
- ram
- tmp
- net_download
- net_upload

Use multibutton to wrap the widget with mouse events:

```
local cpu_widget = sysmonitor.create({mode = "cpu"}).widget

multibutton.create({
  widget = cpu_widget,
  on_click = function()
    system_monitor()
  end,
  on_wheel_down = function()
    decrease_volume()
  end,
  on_wheel_up = function()
    increase_volume()
  end
})
```

More Examples:

```
local cpu_widget = sysmonitor.create({
  mode = "cpu", bgcolor = beautiful.bg_normal, 
  fontcolor = nicegreen, alertcolor = nicered
}).widget

local ram_widget = sysmonitor.create({
  mode = "ram", bgcolor = beautiful.bg_normal, 
  fontcolor = nicegreen, alertcolor = nicered
}).widget

local tmp_widget = sysmonitor.create({
  mode = "tmp", bgcolor = beautiful.bg_normal, 
  fontcolor = nicegreen, alertcolor = nicered
}).widget

local net_download_widget = sysmonitor.create(
  {mode = "net_download", net_interface = "enp40s0f3u2u4",
  bgcolor = beautiful.bg_normal, fontcolor = niceblue, 
  alertcolor = nicered
}).widget

local net_upload_widget = sysmonitor.create(
  {mode = "net_upload", net_interface = "enp40s0f3u2u4",
  bgcolor = beautiful.bg_normal, fontcolor = niceblue, 
  alertcolor = nicered
}).widget
```

`net` modes use "net_interface" which you can pass as an argument.

```
  sysmonitor.create({mode = "net_download", net_interface = "enp40s0f3u2u4"})
  sysmonitor.create({mode = "net_upload", net_interface = "enp40s0f3u2u4"})
```

Every type has an `alert_max` value. If not defined as an argument it uses a default.

When this limit is reached, the font color turns to alertcolor, else it uses fontcolor.

(alert_max of net monitors are calculated in megabits)