local awful = require("awful")
awful.util.shell = "dash"

require("awful.autofocus")
require("modules/theme")
require("modules/utils")
require("modules/screens")
require("modules/clients")
require("modules/notifications")
require("modules/rules")
require("modules/autostart")