local awful = require("awful")

spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("setxkbmap -option caps:none", false)

shellspawn("killall -q plug.sh ; /home/yo/scripts/plug.sh")
shellspawn("killall -q xbindkeys ; xbindkeys")

singlespawn("compton --backend xrender --vsync=true")
singlespawn("copyq")
singlespawn("onboard")
singlespawn("kdeconnect-indicator")