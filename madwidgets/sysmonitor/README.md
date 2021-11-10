# sysmonitor

Show CPU, RAM, or Temperature

## To use it

Put this near the top:
>local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")

Then place it somewhere in the panel:

```
sysmonitor.create({
  mode = "cpu",
  on_click = function()
    sysmonitor()
  end
})
```

Available modes:

- cpu
- ram
- tmp