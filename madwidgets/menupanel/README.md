# menupanel

This creates a panel that can be toggled temporarily to present buttons.

It's meant to replace the main panel until closed.

![](https://i.imgur.com/DktBQcC.gif)

## To use it

Put this near the top
>local menupanel = require("madwidgets/menupanel/menupanel")

Add the following after theme definitions like font size are set:

```lua
local mp_main = menupanel.create({ 
    position = "bottom",
    height = panel_height,
    autoclose = true,
    autoclose_delay = 5,
    hide_button = true,
    speak = false,
    items = {
        {
            name = "Launch an Application",
            action = function() launcher() end,
            hide_on_click = true,
        },
        {
            name = "Open Video On Clipboard",
            action = function() video_from_clipboard() end,
            hide_on_click = true,
        },
        {
            name = "Open Symbols Picker",
            action = function() symbolmenu() end,
            hide_on_click = false,
        },
    }
})
```

You can use instance.create_icon("some text or character") to add a shortcut somewhere in the main panel:
```lua
left = {
    layout = wibox.layout.fixed.horizontal,
    mp_main.create_icon("❇"),
    s.mytaglist,
}
```

You can manually show, hide, and toggle the menu with:

>instance.show()

>instance.hide()

>instance.toggle()

It is able to speak out items if "speak" property is set to true. It uses espeak for this.