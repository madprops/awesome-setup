local ruled = require("ruled")
local naughty = require("naughty")
local gears = require("gears")

naughty.connect_signal("request::display_error", function(message, startup)
  naughty.notification {
    urgency = "critical",
    title   = "Oops, an error happened"..(startup and " during startup!" or "!"),
    message = message
  }
end)

ruled.notification.connect_signal("request::rules", function()
  ruled.notification.append_rule {
    rule = {},
    properties = {
      position = "bottom_right",
      implicit_timeout = 5,
      never_timeout = false,
    }
  }
end)

local icon = gears.filesystem.get_configuration_dir().."icon.png"

naughty.connect_signal("request::display", function(n)
  local txt = trim(n.title)
  local m = trim(n.message)

  if not isempty(m) then
    txt = txt .. " > " .. m
  end

  add_to_log(txt)

  n.title = string.format("<span>%s</span>", n.title)
  n.icon = icon

  naughty.layout.box {
    notification = n
  }
end)