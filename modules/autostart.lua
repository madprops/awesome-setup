local awful = require("awful")

spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("setxkbmap -option caps:none", false)

shellspawn("pkill -f 'clipton'")
sleep(0.25)
shellspawn("python /home/yo/code/clipton/clipton.py watcher")