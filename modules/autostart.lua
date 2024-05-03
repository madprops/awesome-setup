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

-- Clipboard Manager
Utils.spawn("systemctl --user start clipton")

-- Wallpaper
Utils.spawn("feh --bg-fill " .. beautiful.wallpaper)
