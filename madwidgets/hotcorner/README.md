# hotcorner

Create corners that do actions when hovered.

Put this near the top:
>local hotcorner = require("madwidgets/hotcorner/hotcorner")

Create the corners like:

```lua
local corner = hotcorner.create({
  screen = s,
  placement = awful.placement.top_left,
  action = function() some_action_on_mouse_enter() end
  action_2 = function() optional_action_on_mouse_leave() end
})
```