# cpu

Show % of CPU (and others) usage as a text widget.

## To use it

Put this near the top:
>local cpu = require("madwidgets/cpu/cpu")

Then place it somewhere in the panel:

```
cpu.create({
  modes = {"cpu", "ram", "tmp"},
  on_click = function()
    sysmonitor()
  end
})
```

The mousewheel changes the mode, like CPU to RAM.

Available modes:

- cpu
- ram
- tmp