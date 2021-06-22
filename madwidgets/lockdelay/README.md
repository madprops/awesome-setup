# lockdelay

Temporarily lock a function from executing

To create:

Put this near the top:
>local lockdelay = require("madwidgets/lockdelay/lockdelay")

```
lock = lockdelay.create({action=some_function, delay=time_in_milliseconds})
lock.trigger(...)
```