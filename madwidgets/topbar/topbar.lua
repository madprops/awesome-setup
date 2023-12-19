local awful = require("awful")
local wibox = require("wibox")

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
  args.widget = args.widget or wibox.widget{}
  args.screen = args.screen or 1
  args.on_click = args.on_click or function() end
  args.on_right_click = args.on_right_click or function() end
  args.on_middle_click = args.on_middle_click or function() end
  args.on_wheel_up = args.on_wheel_up or function() end
  args.on_wheel_down = args.on_wheel_down or function() end

  instance.widget = awful.wibar({
    position = "top",
    screen = args.screen,
    height = args.height,
    bg = "#2E3440",
  })

  instance.textbox = wibox.widget {
    markup = "",
    align = "center",
    valign = "center",
    widget = wibox.widget.textbox,
  }

  function instance.update(text)
    instance.textbox.markup = "<span font='" .. args.font .. "' color='#FFFFFF'>" .. text .. "</span>"
  end

  function instance.color(color)
    instance.widget.bg = color
  end

  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then
      args.on_click(instance)
    elseif button == 2 then
      args.on_middle_click(instance)
    elseif button == 3 then
      args.on_right_click(instance)
    elseif button == 4 then
      args.on_wheel_up(instance)
    elseif button == 5 then
      args.on_wheel_down(instance)
    end
  end)

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