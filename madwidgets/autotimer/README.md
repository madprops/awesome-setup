![](https://i.imgur.com/AfhYwS3.jpg)

![](https://i.imgur.com/tDSVpl4.jpg)

![](https://i.imgur.com/y8wtB0S.jpg)

```lua
function auto_suspend(minutes)
  autotimer.start_timer("Suspend", minutes, function() suspend() end)
end
```

Use this to perform an action after some minutes.

Or count upwards:

```lua
function counter()
  autotimer.start_counter("My Counter")
end
```

A widget has to be created to show how many minutes are left.

First initialize autotimer:

```lua
autotimer = require("madwidgets/autotimer/autotimer")
autotimer.create({left = " ", right = " "})
```

Then place autotimer where you want the container widget:

```
[widget],
autotimer,
[widget],
```

Middle clicking the widgets stop the actions.

Example:

```lua
autotimer.create({
  fontcolor = "blue",
  left = " ", right = " * ", 
  right_color = "grey",
  separator = "|", separator_color = "red"
})
```

Supports multibutton args plus:

```lua
args = args or {}
args.separator = args.separator or "|"
args.separator_color = args.separator_color or args.fontcolor or "green"
```