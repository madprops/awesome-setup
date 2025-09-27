local gears = require("gears")

Globals = {}

Globals.nicegreen = "#6FE2C8"
Globals.niceblue = "#25AEF3"
Globals.nicered = "#E9006A"
Globals.nicedark = "#445666"
Globals.flower = "❇"
Globals.star = "⍟"
Globals.utils = "🖥️"
Globals.melt = "🫠"
Globals.primary_screen = 2
Globals.volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
Globals.audiocontrol = require("madwidgets/audiocontrol/audiocontrol")
Globals.volumecontrol.max_volume = 99
Globals.conf_dir = gears.filesystem.get_configuration_dir()
