local awful = require("awful")

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end


spawn("numlockx")
spawn("xset m 0 0", false)
spawn("xset r rate 220 40", false)
spawn("setxkbmap -option caps:none", false)

singlespawn("kdeconnect-indicator")

shellspawn("killall -q plug.sh ; /home/yo/scripts/plug.sh")
shellspawn("killall -q xbindkeys ; xbindkeys")

shellspawn("pkill -f 'empris.py autopause'")
shellspawn("pkill -f 'playerctl status --follow'")
sleep(0.1)
shellspawn("python3 /home/yo/code/empris/empris.py autopause")

shellspawn("pkill -f 'clipton.py watcher'")
sleep(0.1)
shellspawn("python3 /home/yo/code/clipton/clipton.py watcher")