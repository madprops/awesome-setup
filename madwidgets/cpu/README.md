# cpu

Show % of CPU (and others) usage as a text widget.

## To use it

Put this near the top:
>local cpu = require("madwidgets/cpu/cpu")

Then place it somewhere in the panel:

>cpu.create()

Accepts text_left and text_right arguments.

Clicking the widget changes from CPU to RAM display.

More modes might be added in the future.