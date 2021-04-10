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
    placement = "bottom",
    autoclose = true,
    autoclose_delay = 1,
    speak = false,
    items = {
        {
            name = "Launch an Application",
            action = function() launcher() end
        },
        {
            name = "Open Video On Clipboard",
            action = function() video_from_clipboard() end,
            needs_confirm = true
        },
        {
            name = "Open Symbols Picker",
            action = function() symbolmenu() end
        },
    }
})
```

All arguments are shown in the example above. It's not necessary to define all of them.

You can manually show, hide, and toggle the menu with:

>instance.show()

>instance.hide()

>instance.toggle()

It is able to speak out items if "speak" property is set to true. It uses espeak for this.

## Used Theme Variables

>beautiful.tasklist_bg_normal

>beautiful.tasklist_fg_normal

>beautiful.tasklist_bg_focus

>beautiful.tasklist_fg_focus

>beautiful.wibar_height

## Mouse Clicks

Button 1 (main click) triggers an action and closes the panel.

Button 2 (middle click) triggers an action but doesn't close the panel.