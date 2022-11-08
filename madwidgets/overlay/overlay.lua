local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local overlay = {}

function overlay.create(args)
  local instance = {}
  args.delay = args.delay or 2
  args.bgcolor = args.bgcolor or "#000000"
  args.fontcolor = args.fontcolor or "#ffffff"
  args.font = args.font or "monospace 20"

  instance.widget = awful.popup({
    placement = "centered",
    ontop = true,
    visible = false,
    border_width = 1,
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg =  args.fontcolor
  })

  instance.textbox = wibox.widget {
    markup = "---:---%",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
    font = args.font
  }  

  instance.widget:setup {
    layout = wibox.layout.align.horizontal,
    instance.textbox
  } 
  
  instance.timer = gears.timer {
    timeout = args.delay,
    autostart = false
  } 

  instance.timer:connect_signal("timeout", function()
    instance.widget.visible = false
  end)  

  function instance.show(text)
    instance.textbox.text = " "..text.." "
    instance.widget.screen = awful.screen.focused()
    instance.widget.visible = true

    if instance.timer.started then
      instance.timer:stop()
    end

    instance.timer:start()
  end

  return instance
end

return overlay