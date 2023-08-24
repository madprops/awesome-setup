local gears = require("gears")

Globals = {}

Globals.nicegreen = "#6FE2C8"
Globals.niceblue = "#25AEF3"
Globals.nicered = "#E9006A"
Globals.nicedark = "#445666"
Globals.flower = "❇"
Globals.star = "⍟"
Globals.primary_screen = 1
Globals.volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
Globals.volumecontrol.max_volume = 80
Globals.conf_dir = gears.filesystem.get_configuration_dir()