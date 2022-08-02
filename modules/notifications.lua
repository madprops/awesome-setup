local ruled = require("ruled")
local naughty = require("naughty")

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
      height = 40
    }
  }
end)

naughty.connect_signal("request::display", function(n)
  n.title = string.format("<span>%s</span>", n.title)
  n.icon = ""
  naughty.layout.box {
    notification = n,
  }
end)