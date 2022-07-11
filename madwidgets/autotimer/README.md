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

```
autotimer.create({minutes = 30, left = " ", right = " "}),
```

Middle clicking the widget cancels the action.