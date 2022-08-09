local awful = require("awful")
local beautiful = require("beautiful")

-- X Settings
Utils.spawn("numlockx")
Utils.spawn("xset m 0 0", false)
Utils.spawn("xset r rate 220 40", false)
Utils.spawn("xset s off", false)
Utils.spawn("xset -dpms", false)
Utils.spawn("xset s noblank", false)
Utils.spawn("setxkbmap -option caps:none", false)

-- Clipboard Manager
Utils.spawn("systemctl --user start clipton", false)

-- Wallpaper
Utils.spawn("feh --bg-fill "..beautiful.wallpaper, false)