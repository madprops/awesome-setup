local awful = require("awful")
local beautiful = require("beautiful")

-- X Settings
Utils.spawn("numlockx")
Utils.spawn("xset m 0 0")
Utils.spawn("xset r rate 220 40")
Utils.spawn("xset s off")
Utils.spawn("xset -dpms")
Utils.spawn("xset s noblank")
Utils.spawn("setxkbmap -option caps:none")
Utils.spawn("xinput set-button-map 11 3 2 1 4 5 6 7 8 9")

-- Clipboard Manager
Utils.spawn("systemctl --user start clipton")

-- Wallpaper
Utils.spawn("feh --bg-fill "..beautiful.wallpaper)