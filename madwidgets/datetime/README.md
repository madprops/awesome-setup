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
    datetime.create()
}
```

Accepts text_left and text_right arguments.

Supports all multibutton mouse action arguments.