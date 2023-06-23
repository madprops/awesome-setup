local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local overlay = {}

function overlay.create(args)
  local instance = {}
  args.delay = args.delay or 1
  args.bgcolor = args.bgcolor or "#445666"
  args.fontcolor = args.fontcolor or "#d5dAf0"
  args.textbox_bgcolor = args.textbox_bgcolor or "#445666"
  args.textbox_fontcolor = args.textbox_fontcolor or "#d5dAf0"
  args.bordercolor = args.bordercolor or "#d5dAf0"
  args.font = args.font or "monospace 16"
  args.height = args.height or 55
  args.borderwidth = args.borderwidth or 1
  args.widget = args.widget or wibox.widget{}
  args.screen = args.screen or 1

  instance.widget = awful.popup({
    placement = "centered",
    ontop = true,
    visible = false,
    border_width = 1,
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg =  args.fontcolor,
    border_color = args.bordercolor,
    border_width = args.borderwidth
  })

  instance.textbox = wibox.widget {
    markup = "---:---%",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox,
    font = args.font,
    forced_height = args.height
  }

  local textbox = wibox.widget {
    instance.textbox,
    widget = wibox.container.background,
    bg = args.textbox_bgcolor,
    fg = args.textbox_fontcolor
  }

  instance.widget:setup {
    layout = wibox.layout.align.vertical,
    textbox,
    args.widget
  }

  instance.widget:connect_signal("mouse::enter", function()
    instance.hide()
  end)

  instance.timer = gears.timer {
    timeout = args.delay,
    autostart = false
  }

  instance.timer:connect_signal("timeout", function()
    instance.hide()
  end)

  function instance.hide()
    instance.widget.visible = false
  end

  function instance.show(text)
    instance.textbox.text = " "..text.." "
    instance.widget.screen = args.screen
    instance.widget.visible = true

    if instance.timer.started then
      instance.timer:stop()
    end

    instance.timer:start()
  end

  return instance
end

return overlay