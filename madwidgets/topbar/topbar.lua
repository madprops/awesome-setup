local awful = require("awful")
local wibox = require("wibox")

local topbar = {}

function topbar.create(args)
  local instance = {}
  args.delay = args.delay or 1.5
  args.bgcolor = args.bgcolor or "#445666"
  args.fontcolor = args.fontcolor or "#d5dAf0"
  args.bordercolor = args.bordercolor or "#d5dAf0"
  args.font = args.font or "monospace 16"
  args.height = args.height or 55
  args.borderwidth = args.borderwidth or 1
  args.widget = args.widget or wibox.widget{}
  args.screen = args.screen or 1

  instance.widget = awful.wibar({
    position = "top",
    screen = args.screen,
    height = 30,
    bg = "#2E3440",
  })

  instance.textbox = wibox.widget {
    markup = "",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  }

  function instance.update(text)
    instance.textbox.markup = "<span font='Sans 12' color='#FFFFFF'>" .. text .. "</span>"
  end

  function instance.color(color)
    instance.widget.bg = color
  end

  instance.widget:setup {
    layout = wibox.layout.align.horizontal,
    {
      widget = wibox.widget.textbox,
    },
    instance.textbox,
    {
      widget = wibox.widget.textbox,
    },
  }

  return instance
end

return topbar