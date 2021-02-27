# hotcorner

Create corners that do actions when hovered.

Put this near the top:
>local hotcorner = require("madwidgets/hotcorner/hotcorner")

Create the corners like:

```lua
hotcorner.create({
  placement = awful.placement.top_left,
  action = function() some_action() end
})
```