![](https://i.imgur.com/AfhYwS3.jpg)

![](https://i.imgur.com/tDSVpl4.jpg)

![](https://i.imgur.com/y8wtB0S.jpg)

```lua
function auto_suspend(minutes)
  autotimer.start_timer("Suspend", function() suspend() end, minutes)
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

Middle clicking the widgets cancels the actions.