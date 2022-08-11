local awful = require("awful")
awful.util.shell = "dash"

require("awful.autofocus")
require("modules/notifications")
require("modules/globals")
require("modules/utils")
require("modules/bindings")
require("modules/theme")
require("modules/screens")
require("modules/clients")
require("modules/rules")
require("modules/menupanels")
require("modules/autostart")