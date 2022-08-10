Globals = {}

Globals.nicegreen = "#6FE2C8"
Globals.niceblue = "#1880EB"
Globals.nicered = "#E9006A"
Globals.nicedark = "#445666"
Globals.flower = "❇"
Globals.star = "⍟"
Globals.primary_screen = 1
Globals.volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
Globals.autotimer = require("madwidgets/autotimer/autotimer")
Globals.autotimer.create({
  left = " >", right = "<", left_color = Globals.nicered, right_color = Globals.nicered
})