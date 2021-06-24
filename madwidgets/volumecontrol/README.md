# volumecontrol

This creates a text based volume widget and provides volume control functions.

The widget is only updated when the volumecontrol volume functions are used.

So there's no constant polling/checking of volume levels.

The widget includes mouse events on click, middle click, and mousewheel.

![](https://i.imgur.com/5Ybd9gF.jpg)

## To use it

Put this near the top
>local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")

Then add the widget to the panel, similar to:

```lua
right = {
    layout = right_layout,
    wibox.widget.systray(),
    volumecontrol.create(),
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

volumecontrol.max()
>Sets volume to 100%

---

volumecontrol.mute()
>Toggle between 0% volume and last used volume

---

volumecontrol.refresh()
>Updates the volume level. Meant to be ran once at startup

## Variables

volumecontrol.max_volume
>Default: 100 (%)

---

volumecontrol.steps
>Default 5 (% - used in increase and decrease)