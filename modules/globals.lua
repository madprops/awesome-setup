Global = {}

Global.nicegreen = "#6FE2C8"
Global.niceblue = "#1880EB"
Global.nicered = "#E9006A"
Global.primary_screen = 1
Global.volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
Global.autotimer = require("madwidgets/autotimer/autotimer")
Global.autotimer.create({
  left = " >", right = "<", left_color = Global.nicered, right_color = Global.nicered
})