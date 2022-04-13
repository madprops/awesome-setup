local wibox = require("wibox")
local textblock = {}

function textblock.create(args)
  args = args or {}

  local instance = {}
  instance.args = args
  args.text = args.text or " "
  args.bgcolor = args.bgcolor or "#2B303B"
  args.fontcolor = args.fontcolor or "#b8babc"

  instance.textbox_widget = wibox.widget {
    align  = 'center',
    valign = 'center',
    text = args.text,
    widget = wibox.widget.textbox
  }

  instance.widget = wibox.widget {
    instance.textbox_widget,
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg = args.fontcolor
  }

  return instance
end

return textblock