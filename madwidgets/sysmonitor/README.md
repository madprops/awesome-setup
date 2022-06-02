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
local cpu_widget = sysmonitor.create({
  mode = "cpu", bgcolor = beautiful.bg_normal, 
  fontcolor = nicegreen, alertcolor = nicered
}).widget

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

Every type has an `alert_max` value. If not defined as an argument it uses a default.

When this limit is reached, the font color turns to alertcolor, else it uses fontcolor.

(alert_max of net monitors are calculated in megabits)

A specific command to be used can be passed with the "command" argument.

A specific timer timeout to be used can be passed with the "timeout" argument.