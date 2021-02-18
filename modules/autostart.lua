local awful = require("awful")

awful.spawn.single_instance("compton --backend xrender")
awful.spawn.single_instance("copyq")
awful.util.spawn_with_shell("pkill dubya.js; /home/yo/code/dubya/dubya.js", false)
awful.util.spawn("xset m 0 0", false)
awful.util.spawn("xset r rate 220 40", false)
awful.util.spawn("setxkbmap -option caps:none", false)