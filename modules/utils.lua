local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local menupanels = require("modules/menupanels")
local lockdelay = require("madwidgets/lockdelay/lockdelay")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local context_client

function msg(txt)
  naughty.notify({text = " "..tostring(txt).." "})
end

function prev_client()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end

function center(c)
  awful.placement.centered(c, {honor_workarea = true})
end

function maximize(c)
  c.maximized = not c.maximized
  focus(c)
end

function fullscreen(c)
  c.fullscreen = not c.fullscreen
  focus(c)
end

function check_fullscreen(c)
  myscreen().mywibar.ontop = not c.fullscreen
end

function focus(c)
  c:emit_signal("request::activate", "tasklist", {raise = true})
end

function close(c)
  c:kill()
end

function snap(c, axis, position)
  local f
  
  c.maximized = false

  if axis == "corner" then
    f = awful.placement.scale + position
  else
    f = awful.placement.scale + position + (axis and awful.placement["maximize_" .. axis] or nil)
  end

  f(c, {
    honor_workarea = true,
    to_percent = 0.5
  })
end

function launcher()
  spawn("rofi -modi drun -show drun -show-icons -width 22 -no-click-to-exit")
end

function altab()  
  spawn("rofi -show window -show-icons -width 44 -no-click-to-exit")
end

function screenshot()
  spawn("spectacle -r " .. os.getenv("HOME") .. "/Downloads/pics/pics1")
end

function media_play_pause()
  spawn("python3 /home/yo/code/empris/empris.py")
end

function media_next()
  spawn("python3 /home/yo/code/empris/empris.py next")
end

function media_prev()
  spawn("python3 /home/yo/code/empris/empris.py prev")
end

function randstring()
  spawn(os.getenv("HOME") .. "/scripts/randword.sh")
end

function randword()
  spawn(os.getenv("HOME") .. "/scripts/randword.sh word")
end

function to_clipboard(text)
  shellspawn('echo -n "'..trim(text)..'" | xclip -selection clipboard')
end

function trim(text)
  return (string.gsub(text, "^%s*(.-)%s*$", "%1"))
end

function show_menupanel()
  menupanels.main.show()
end

function get_context_client()
  return context_client
end

function show_task_context(c)
  context_client = c
  menupanels.context.show_with_delay()
end

function show_client_title(c)
  menupanels.utils.showinfo(c.name)
end

function dropdown()
  spawn("tilix --quake")
end

function stop_all_players()
  spawn("python3 /home/yo/code/empris/empris.py pauseall")
end

function lockscreen(suspend)
  local s = ""

  if suspend then
    s = "systemctl suspend; "
  end

  shellspawn(s.."i3lock --color=000000 -n")
end

local logpath = os.getenv("HOME") .. "/.config/clickthing/clicks.txt"

function add2log(name)
  local txt = name.." "..os.date("%c")
  shellspawn("echo -e '"..txt.."' | cat - "..logpath.." | sponge "..logpath)
  msg(name .. " added to log")
end

function showlog(name)
  shellspawn("kwrite "..logpath)
end

function calendar()
  spawn("osmo")
end

function increase_volume()
  volumecontrol.increase()
end

function decrease_volume()
  volumecontrol.decrease()
end

function refresh_volume()
  volumecontrol.refresh()
end

function spawn(program)
  awful.util.spawn(program, false)
end

function shellspawn(program)
  awful.util.spawn_with_shell(program, false)
end

function singlespawn(program)
  awful.spawn.single_instance(program)
end

function launch_all()
  spawn("firefox-trunk")
  spawn("code")
  spawn("spotify")
  spawn("strawberry")
  spawn("hexchat")
  spawn("steam")
  spawn("dolphin")
end

function show_main_menu()
  menupanels.main.show() 
end

function width_factor(n)
  return myscreen().workarea.width * n
end

function height_factor(n)
  return myscreen().workarea.height * n
end

function ratio(c)
  return c.width / c.height
end

function grow_in_place(c)
  c.maximized = false
  c.height = c.height + 20
  c.width = c.width + (20 * ratio(c))
  center(c)
end

function shrink_in_place(c)
  c.maximized = false
  c.height = c.height - 20
  c.width = c.width - (20 * ratio(c))
  center(c)
end

local minimize_lock = lockdelay.create({
  action = function()
    for _, c in ipairs(clients()) do
      c.minimized = true
    end
  end,
  delay = 250
})

local unminimize_lock = lockdelay.create({
  action = function()
    for _, c in ipairs(clients()) do
      c.minimized = false
    end
  end,
  delay = 250
})

function minimize_all()
  minimize_lock.trigger()
end

function unminimize_all()
  unminimize_lock.trigger()
end

function myscreen()
  return awful.screen.focused()
end

function mytag()
  return myscreen().selected_tag
end

function clients()
  return mytag():clients()
end

function system_monitor()
  spawn("konsole -e htop -d 20")
end

function space()
  return wibox.widget.textbox("  ")
end

function show_clipboard()
  spawn("python3 /home/yo/code/clipton/clipton.py")
end