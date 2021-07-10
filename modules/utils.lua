local awful = require("awful")
local naughty = require("naughty")
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
  focus(c)
  c.maximized = not c.maximized
end

function fullscreen(c)
  focus(c)
  c.fullscreen = not c.fullscreen
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
  spawn("flameshot gui -p " .. os.getenv("HOME") .. "/Downloads/pics/pics1")
end

local playerctl_lock = lockdelay.create({
  action = function(action) spawn("playerctl -i firefox "..action) end,
  delay = 250
})

function playerctl(player)
  playerctl_lock.trigger(player)
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
  shellspawn("playerctl --all-players pause")
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
  spawn("firefox")
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
  return awful.screen.focused().workarea.width * n
end

function height_factor(n)
  return awful.screen.focused().workarea.height * n
end

function ratio(c)
  return c.width / c.height
end

function grow_in_place(c)
  c.height = c.height + 20
  c.width = c.width + (20 * ratio(c))
  center(c)
end

function shrink_in_place(c)
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

function tag()
  return awful.screen.focused().selected_tag
end

function clients()
  return tag():clients()
end

function sysmonitor()
  spawn("konsole -e htop -d 20")
end