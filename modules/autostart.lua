local awful = require("awful")

-- X Settings
spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("xset s off", false)
spawn("xset -dpms", false)
spawn("xset s noblank", false)
spawn("setxkbmap -option caps:none", false)

-- Clipboard Manager
spawn("systemctl --user start clipton", false)