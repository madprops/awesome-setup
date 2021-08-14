local awful = require("awful")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")

local datetime = {}

function datetime.create(args)
  args = args or {}
  args.format = args.format or "%a-%d-%b %I:%M %P"

  local instance = {}
  instance.args = args
  args.widget = wibox.widget.textclock(args.format, 15)
  instance.widget = multibutton.create(args).widget

  awful.tooltip {
    objects = { instance.widget },
    timer_function = function()
      local text = ""
      text = text..os.date('%T\n%A %B (%m) %d %Y')
      return text
    end,
    delay_show = 1
  }

  return instance
end

return datetime