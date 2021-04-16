local awful = require("awful")

awful.spawn.single_instance("compton --backend xrender")
awful.spawn.single_instance("copyq")
awful.util.spawn("xset m 0 0", false)
awful.util.spawn("xset r rate 220 40", false)
awful.util.spawn("setxkbmap -option caps:none", false)
awful.util.spawn_with_shell("killall -q plug.sh ; /home/yo/scripts/plug.sh", false)