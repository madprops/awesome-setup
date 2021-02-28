# multibutton

Generic programmable button that is easy to bind click events to.

Put this near the top:
>local multibutton = require("madwidgets/multibutton/multibutton")

Then include the button or buttons somewhere like:

```lua
left = {
  layout = wibox.layout.fixed.horizontal,
  multibutton.create({
    text = "❇",
    on_click = function(btn) 
      menupanels.main.toggle() 
    end,
    on_middle_click = function(btn)
      lockscreen()
    end,
    on_right_click = function(btn)
      dropdown()
    end,
    on_wheel_up = function(btn)
      prev_tag()
    end,
    on_wheel_down = function(btn)
      next_tag()
    end,
    on_mouse_enter = function(btn)
      something()
    end,
    on_mouse_leave = function(btn)
      something()
    end,
  }),
  s.mytaglist,
  wibox.widget.textbox("  "),
}
```

All options are shown in the example above.