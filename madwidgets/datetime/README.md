# datetime

This creates a simple clock widget that shows the date and time.

It adds a tooltip on hover which shows more information.

Mouse events can be configured.

Put this near the top
>local datetime = require("madwidgets/datetime/datetime")

Add something similar to a wibar:

```lua
right = {
    layout = right_layout,
    wibox.widget.systray(),
    datetime.create({
        on_click = function()
            calendar()
        end,
        on_right_click = function()
            something()
        end,
        on_middle_click = function()
            action()
        end,
        on_wheel_up = function()
            increase_volume()
        end,
        on_wheel_down = function()
            decrease_volume()
        end
    })
}
```