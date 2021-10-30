local awful = require("awful")

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("setxkbmap -option caps:none", false)

shellspawn("pkill -f 'empris.py autopause'")
shellspawn("pkill -f 'playerctl status --follow'")
sleep(0.25)
shellspawn("python /home/yo/code/empris/empris.py autopause")

shellspawn("pkill -f 'clipton'")
sleep(0.25)
shellspawn("python /home/yo/code/clipton/clipton.py watcher")