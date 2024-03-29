# volumecontrol

This creates a text based volume widget and provides volume control functions.

The widget includes mouse events on click, middle click, and mousewheel.

![](https://i.imgur.com/5Ybd9gF.jpg)

## To use it

Put this near the top:
>local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")

Then add the widget to the panel, similar to:

```lua
right = {
    layout = right_layout,
    wibox.widget.systray(),

    volumecontrol.create({
        bgcolor = beautiful.bg_normal,
        left = " ", right = " ",
        on_click = function() do_something() end
    }),

    mytextclock
}
```

You can add keyboard shortcuts like:

```lua
awful.key({}, "XF86AudioRaiseVolume", function()
    volumecontrol.increase()
end), 

awful.key({}, "XF86AudioLowerVolume", function()
    volumecontrol.decrease()
end),
```

## Functions

volumecontrol.set(number)
>Set the volume to a specific %

---

volumecontrol.increase()
>Increase volume by a % step

---

volumecontrol.decrease()
>Decrease volume by a % step

---

volumecontrol.mute()
>Toggle between 0% volume and last used volume

---

volumecontrol.refresh()
>Updates the widgets volume text.

## Variables

volumecontrol.max_volume
>Default: 100 (%)

---

volumecontrol.steps
>Default 5 (% - used in increase and decrease)