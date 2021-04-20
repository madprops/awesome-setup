# doubletap

This simulates a double-click trigger.

To create:

Put this near the top:
>local doubletap = require("madwidgets/doubletap/doubletap")

```lua
local mytap = doubletap.create({
  delay = 300,
  action = function()
    something()
  end
})
```

To trigger just bind instance.trigger() to some keybind:

```lua
awful.key({modkey}, "Delete", function()
  mytap.trigger()
end)
```

So for instance if modkey+delete is triggered twice before 300ms, it will trigger the action.

## Example Usage

Map a key combo to the dpi button or some other convenient button of your mouse.

Bind a doubletap to that key combo.

Double click the button to trigger an action to close the client below the cursor.

This is a quick way to close windows.

```lua
local closetap = doubletap.create({
  delay = 300,
  lockdelay = 1000,
  action = function()
    mouse.object_under_pointer():kill()
  end
})
```

>delay (ms)

Two taps need to happen <= this range to trigger. So for instance 200 needs quick taps while 2000 can be slow taps.

>lockdelay (ms)

After the last trigger, the taps will be locked until this time has passed. This is to avoid accidental double taps in some cases.