local awful = require("awful")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")

local datetime = {}

function datetime.create(args)
  args.text_left = args.text_left or ""
  args.text_right = args.text_right or ""

  local instance = {}
  instance.args = args
  args.widget = awful.widget.textclock(args.text_left.."%a %d %b %l:%M %P"..args.text_right, 15)
  instance.widget = multibutton.create(args).widget

  awful.tooltip {
    objects = { instance.widget },
    timer_function = function()
      local text = ""
      text = text..os.date('%T\n%A %B (%m) %d %Y')
      return text
    end
  }  

  return instance
end

return datetime