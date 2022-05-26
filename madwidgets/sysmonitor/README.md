# sysmonitor

Show CPU, RAM, or Temperature

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

`net` modes use "net_interface" which you can pass as an argument.

```
  sysmonitor.create({mode = "net_download", net_interface = "enp40s0f3u2u4"})
  sysmonitor.create({mode = "net_upload", net_interface = "enp40s0f3u2u4"})
```