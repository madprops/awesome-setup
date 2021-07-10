# menupanel

This creates a panel that can be toggled temporarily to present buttons.

It's meant to replace the main panel until closed.

![](https://i.imgur.com/RNzCGCX.jpg)

## To use it

Put this near the top:
>local menupanel = require("madwidgets/menupanel/menupanel")

Add the following after theme definitions like font size are set:

```lua
local mp_main = menupanel.create({ 
    placement = "bottom",
    height = 25,
    speak = false,
    hide_button = true,
    hide_button_placement = "left",
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

It is able to speak out items if "speak" property is set to true. It uses espeak for this.

## Actions

Click (or Enter) triggers an action and hides the panel.

Middle click (or Shift+Enter) triggers an action but doesn't hide the panel.

There is a 'parent' property that can reference another menupanel instance.
Doing this enables showing the parent menupanel when Esc is pressed on the current menupanel.
This is a way to form menus with submenus using multiple menupanels. 

Escape or clicking the x button hides the menupanel or goes to parent.

Shift+Escape hides the menupanel completely (doesn't go to parent)

## Theming

You can use these arguments to customize the look of a menupanel:

>bgcolor

>bgcolor2

>fontcolor

>bordercolor

>bordercolor2


There's an instance method to update an item programatically:

>instance.update_item(index, name, action)