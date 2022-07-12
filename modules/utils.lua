local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local menupanels = require("modules/menupanels")
local lockdelay = require("madwidgets/lockdelay/lockdelay")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local context_client

function msg(txt)
  naughty.notify({text = " " .. tostring(txt) .. " ", screen = primary_screen})
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

function on_top(c)
  c.ontop = not c.ontop
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

local media_lock = lockdelay.create({action=function(cmd)
  spawn(cmd)
end, delay=250})

function media_play_pause()
  media_lock.trigger("playerctl -p audacious play-pause")
end

function randstring()
  spawn(os.getenv("HOME") .. "/scripts/randword.sh")
end

function randword()
  spawn(os.getenv("HOME") .. "/scripts/randword.sh word")
end

function to_clipboard(text)
  shellspawn('echo -n "' .. trim(escape_quotes(text)) .. '" | xclip -selection clipboard')
end

function escape_quotes(text)
  return string.gsub(text, '"', "\\\"")
end

function trim(text)
  return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

function startswith(s1, s2)
  return string.sub(s1, 1, string.len(s2)) == s2
end

function show_menupanel(mode)
  menupanels.main.start(mode)
end

function get_context_client()
  return context_client
end

function show_task_context(c)
  context_client = c
  menupanels.context.start("mouse")
end

function show_client_title(c)
  menupanels.utils.showinfo(c.name)
end

function dropdown()
  spawn("tilix --quake")
end

function stop_all_players()
  spawn("playerctl --all-players pause")
end

function lockscreen(suspend)
  local s = ""

  if suspend then
    s = "systemctl suspend; "
  end

  shellspawn(s .. "i3lock --color=000000 -n")
end

function suspend()
  lockscreen(true)
end

function unlockscreen()
  shellspawn("killall i3lock")
end

function alt_lockscreen()
  stop_all_players()
  open_empty_tab()
  lockscreen()
end

function open_empty_tab()
  shellspawn("firefox --new-tab --url about:newtab")
end

local logpath = os.getenv("HOME") .. "/.config/clickthing/clicks.txt"

function add2log(name)
  local txt = name .. " " .. os.date("%c")
  shellspawn("echo '" .. txt .. "' | cat - " .. logpath .. " | sponge " .. logpath)
  msg(name .. " added to log")
end

function showlog(name)
  shellspawn("geany " .. logpath)
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

function set_volume(v)
  volumecontrol.set_round(v)
end

function refresh_volume()
  volumecontrol.refresh()
end

function spawn(program)
  awful.spawn(program, false)
end

function shellspawn(program)
  awful.spawn.with_shell(program, false)
end

function singlespawn(program)
  awful.spawn.single_instance(program)
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
  focus(c)
  c.maximized = false
  c.height = c.height + 20
  c.width = c.width + (20 * ratio(c))
  center(c)
end

function shrink_in_place(c)
  focus(c)
  c.maximized = false
  c.height = c.height - 20
  c.width = c.width - (20 * ratio(c))
  center(c)
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
  spawn("alacritty -e htop -d 20")
end

-- To run nethogs without sudo you need to do this once:
-- sudo setcap "cap_net_admin,cap_net_raw=ep" /usr/bin/nethogs
function network_monitor()
  spawn("alacritty -e nethogs")
end

function space()
  return wibox.widget.textbox(" ")
end

function show_clipboard()
  spawn("clipton")
end

function switch_tag(direction, sticky)
  local index = mytag().index
  local num_tags = #myscreen().tags

  local ok = (direction == "next" and index < num_tags) 
          or (direction == "prev" and index > 1)

  if ok then
    local new_index

    if direction == "next" then 
      new_index = index + 1
    elseif direction == "prev" then
      new_index = index - 1
    end

    local new_tag = myscreen().tags[new_index]

    if sticky then
      if client.focus and client.focus.screen == myscreen() then
        client.focus:move_to_tag(new_tag)
      end
    end

    new_tag:view_only()
  end
end

function next_tag(sticky)
  switch_tag("next", sticky)
end

function prev_tag(sticky)
  switch_tag("prev", sticky)
end

function next_tag_all()
  i = mytag().index + 1

  if i > #myscreen().tags then
    i = #myscreen().tags
  end

  for s in screen do
    goto_tag(s, i)
  end
end

function prev_tag_all()
  i = mytag().index - 1

  if i < 1 then
    i = 1
  end
  
  for s in screen do
    goto_tag(s, i)
  end
end

function goto_tag(s, i)
  local tag = s.tags[i]
  if tag then
    tag:view_only()
  end
end

function reset_rules(c)
  awful.rules.apply(c)
  check_title_rules(c)
end

function sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function show_audio_controls()
  spawn("pavucontrol")
end

function move_to_tag(t)
  if client.focus then
    client.focus:move_to_tag(t)
    t:view_only()
  end
end

function auto_suspend(minutes)
  autotimer.start("Suspend", function() suspend() end, minutes)
end

function timer(minutes)
  autotimer.start("Timer", function() 
    msg("Timer ended") 
  end, minutes)
end