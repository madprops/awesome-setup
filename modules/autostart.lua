local awful = require("awful")

spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("xset s off", false)
spawn("xset -dpms", false)
spawn("xset s noblank", false)
spawn("setxkbmap -option caps:none", false)