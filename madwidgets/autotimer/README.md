```
function auto_suspend(minutes)
  autotimer.start("Suspend", function() lockscreen(true) end, minutes)
end

function cancel_auto_suspend()
  autotimer.cancel()
end
```

You can use this to perform an action after some minutes.

A widget can be created to show how many minutes are left.

First initialize autotimer:

```
autotimer = require("madwidgets/autotimer/autotimer")
autotimer.create({left = " ", right = " "})
```

Then place autotimer where you want the container widget:

```
[widget],
autotimer,
[widget],
```

Middle clicking the widget cancels the actions.