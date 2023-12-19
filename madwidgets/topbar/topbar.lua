local awful = require("awful")
local wibox = require("wibox")

local multibutton = require("madwidgets/multibutton/multibutton")

local topbar = {}

function topbar.create(args)
  local instance = {}
  args.delay = args.delay or 1.5
  args.bgcolor = args.bgcolor or "#445666"
  args.fontcolor = args.fontcolor or "#d5dAf0"
  args.bordercolor = args.bordercolor or "#d5dAf0"
  args.font = args.font or "monospace 11"
  args.height = args.height or 22
  args.borderwidth = args.borderwidth or 1
  args.screen = args.screen or 1

  instance.widget = awful.wibar({
    position = "top",
    screen = args.screen,
    height = args.height,
  })

  args.text = "Tagbar"
  args.bgcolor = "#2E3440"
  instance.multibutton = multibutton.create(args)

  function instance.update(text)
    instance.multibutton.textbox.markup = "<span font='" .. args.font .. "' color='#FFFFFF'>" .. text .. "</span>"
  end

  function instance.color(color)
    instance.multibutton.widget.bg = color
  end

  instance.widget:setup {
    layout = wibox.layout.align.horizontal,
    {
      widget = wibox.widget.textbox,
    },
    instance.multibutton.widget,
    {
      widget = wibox.widget.textbox,
    },
  }

  return instance
end

return topbar