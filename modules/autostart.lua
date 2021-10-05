local awful = require("awful")

spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("setxkbmap -option caps:none", false)

shellspawn("killall -q plug.sh ; /home/yo/scripts/plug.sh")
shellspawn("killall -q xbindkeys ; xbindkeys")
shellspawn("pkill -f 'empris.py autopause'")
shellspawn("pkill -f 'playerctl status --follow'")
shellspawn("python3 /home/yo/code/empris/empris.py autopause")

singlespawn("copyq")
singlespawn("kdeconnect-indicator")