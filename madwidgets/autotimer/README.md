```
function auto_suspend(minutes)
  autotimer.start("Suspend", function() suspend() end, minutes)
end
```

Use this to perform an action after some minutes.

A widget has to be created to show how many minutes are left.

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

Middle clicking the widgets cancels the actions.