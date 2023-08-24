Utils = {}
Utils.util_screen_on = false

local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local lockdelay = require("madwidgets/lockdelay/lockdelay")
local autotimer = require("madwidgets/autotimer/autotimer")
local context_client

local media_lock = lockdelay.create({action=function(cmd)
  Utils.spawn(cmd)
end, delay=250})

local tag_next_lock = lockdelay.create({action=function(sticky)
  if Utils.util_screen_on then
    if Utils.util_screen_screen == Utils.myscreen() then
      Utils.hide_util_screen()
    end
  end

  Utils.switch_tag("next", sticky)
end, delay=100})

local tag_prev_lock = lockdelay.create({action=function(sticky)
  if Utils.util_screen_on then
    if Utils.util_screen_screen == Utils.myscreen() then
      Utils.hide_util_screen()
    end
  end

  Utils.switch_tag("prev", sticky)
end, delay=100})

local util_screen_lock = lockdelay.create({action=function()
  Utils.do_show_util_screen()
end, delay=250})

function Utils.msg(txt, info)
  local run = function() end

  if info and Utils.startswith(info, "https://") then
    run = function() Utils.open_tab(info) end
  end

  local n = naughty.notify({title = " " .. tostring(txt) .. " "})

  n:connect_signal("destroyed", function(n, reason)
    if reason == naughty.notification_closed_reason.dismissed_by_user then
      run()
    end
  end)
end

function Utils.prev_client()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end

function Utils.center(c)
  awful.placement.centered(c, {honor_workarea = true})
end

function Utils.maximize(c)
  c.maximized = not c.maximized
  Utils.focus(c)
end

function Utils.fullscreen(c)
  c.fullscreen = not c.fullscreen
  Utils.focus(c)
end

function Utils.on_top(c)
  c.ontop = not c.ontop
end

function Utils.check_fullscreen(c)
  Utils.myscreen().mywibar.ontop = not c.fullscreen
end

function Utils.focus(c)
  c:emit_signal("request::activate", "tasklist", {raise = true})
end

function Utils.close(c)
  c:kill()
end

function Utils.snap(c, axis, position)
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

function Utils.launcher()
  Utils.spawn("rofi -modi drun -show drun -show-icons -no-click-to-exit")
end

function Utils.altab()
  Utils.spawn("rofi -show window -show-icons -no-click-to-exit")
end

function Utils.screenshot()
  Utils.spawn("flameshot gui")
end

function Utils.screenshot_window()
  Utils.spawn("spectacle -a")
end

function Utils.screenshot_screen()
  Utils.spawn("spectacle -m")
end

function Utils.randstring()
  Utils.home_run("randword.sh")
end

function Utils.randword()
  Utils.home_run("randword.sh word")
end

function Utils.to_clipboard(text)
  Utils.shellspawn('echo -n "' .. Utils.trim(Utils.escape_quotes(text)) .. '" | xclip -selection clipboard')
end

function Utils.escape_quotes(text)
  return string.gsub(text, '"', "\\\"")
end

function Utils.trim(text)
  return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

function Utils.startswith(s1, s2)
  return string.sub(s1, 1, string.len(s2)) == s2
end

function Utils.show_menupanel(mode)
  Menupanels.main.start(mode)
end

function Utils.get_context_client()
  return context_client
end

function Utils.show_task_context(c)
  context_client = c
  Menupanels.context.start("mouse")
end

function Utils.show_client_title(c)
  Menupanels.utils.showinfo(c.name)
end

function Utils.start_util_screen()
  Utils.spawn("dolphin")
  Utils.spawn("speedcrunch")
  Utils.spawn("tilix --session ~/other/tilix.json")
end

function Utils.toggle_util_screen()
  if Utils.util_screen_on then
    local highest = Utils.highest_in_tag(Utils.util_screen_tag)
    local same_tag = Utils.util_screen_tag == Utils.mytag()

    if not same_tag or not Utils.util_screen_tag.selected or (highest ~= nil and not highest.xutil) then
      Utils.show_util_screen()
    else
      Utils.hide_util_screen()
    end
  else
    Utils.show_util_screen()
  end
end

function Utils.show_util_screen()
  util_screen_lock.trigger()
end

function Utils.do_show_util_screen()
  local t = Utils.mytag()

  for _, c in ipairs(client.get()) do
    if c.xutil then
      c:move_to_tag(t)
      c.hidden = false
      c:raise()
      Rules.reset_rules(c)
    end
  end

  Utils.util_screen_on = true
  Utils.util_screen_screen = Utils.myscreen()
  Utils.util_screen_tag = Utils.mytag()
end

function Utils.hide_util_screen()
  for _, c in ipairs(client.get()) do
    if c.xutil then
      c.hidden = true
    end
  end

  Utils.util_screen_on = false
end

function Utils.stop_all_players()
  Utils.spawn("playerctl --all-players pause")
end

function Utils.lockscreen(suspend)
  local s = ""

  if suspend then
    s = "systemctl suspend; "
  end

  Utils.shellspawn(s .. "i3lock --color=000000 -n")
end

function Utils.suspend()
  Utils.lockscreen(true)
end

function Utils.unlockscreen()
  Utils.shellspawn("killall i3lock")
end

function Utils.alt_lockscreen()
  Utils.stop_all_players()
  Utils.lockscreen()
end

function Utils.open_tab(url)
  Utils.shellspawn("firefox-developer-edition --new-tab --url '"..url.."'")
end

function Utils.add_to_file(path, text, num)
  Utils.shellspawn("echo '" .. text .. "' | cat - " .. path .. " | sponge " .. path .. " && sed -i '" .. num..",$ d' " .. path)
end

local log_path = os.getenv("HOME") .. "/.awm_log"

function Utils.add_to_log(text, announce)
  local txt = os.date("%c") .. " " .. Utils.trim(text)
  Utils.add_to_file(log_path, txt, 1000)

  if announce then
    Utils.msg("Added to log: " .. text)
  end
end

function Utils.show_log(name)
  Utils.shellspawn("geany " .. log_path)
end

local notifications_path = os.getenv("HOME") .. "/.awm_notifications"

function Utils.add_to_notifications(text)
  local clean = Utils.trim(text)

  if Utils.startswith(clean, "Volume:") then
    return
  end

  local txt = os.date("%c") .. " " .. clean
  Utils.add_to_file(notifications_path, txt, 1000)
end

function Utils.show_notifications(name)
  Utils.shellspawn("geany " .. notifications_path)
end

function Utils.calendar()
  Utils.spawn("osmo")
end

function Utils.increase_volume(osd)
  Globals.volumecontrol.increase(osd)
end

function Utils.decrease_volume(osd)
  Globals.volumecontrol.decrease(osd)
end

function Utils.set_volume(v)
  Globals.volumecontrol.set_round(v)
end

function Utils.refresh_volume()
  Globals.volumecontrol.refresh()
end

function Utils.spawn(cmd)
  awful.spawn(cmd, false)
end

function Utils.shellspawn(cmd)
  awful.spawn.with_shell(cmd, false)
end

function Utils.singlespawn(cmd)
  awful.spawn.single_instance(cmd)
end

function Utils.home_run(cmd)
  Utils.spawn(os.getenv("HOME") .. "/scripts/" .. cmd)
end

function Utils.home_bin(cmd)
  Utils.spawn(os.getenv("HOME") .. "/bin/" .. cmd)
end

function Utils.width_factor(n)
  return Utils.myscreen().workarea.width * n
end

function Utils.height_factor(n)
  return Utils.myscreen().workarea.height * n
end

function Utils.ratio(c)
  return c.width / c.height
end

function Utils.grow_in_place(c)
  Utils.focus(c)
  c.maximized = false
  c.height = c.height + 20
  c.width = c.width + (20 * Utils.ratio(c))
  Utils.center(c)
end

function Utils.shrink_in_place(c)
  Utils.focus(c)
  c.maximized = false
  c.height = c.height - 20
  c.width = c.width - (20 * Utils.ratio(c))
  Utils.center(c)
end

function Utils.myscreen()
  return awful.screen.focused()
end

function Utils.mytag()
  return Utils.myscreen().selected_tag
end

function Utils.clients()
  return Utils.mytag():clients()
end

function Utils.open_terminal(cmd)
  Utils.spawn("alacritty -o font.size=12 -e "..cmd)
end

function Utils.system_monitor()
  Utils.open_terminal("btop")
end

function Utils.system_monitor_temp()
  Utils.open_terminal("watch -n 2 sensors")
end

-- To run nethogs without sudo you need to do this once:
-- sudo setcap "cap_net_admin,cap_net_raw=ep" /usr/bin/nethogs
function Utils.network_monitor()
  Utils.open_terminal("nethogs")
end

function Utils.space()
  return wibox.widget.textbox(" ")
end

function Utils.show_clipboard()
  Utils.spawn("clipton")
end

function Utils.switch_tag(direction, sticky)
  local index = Utils.mytag().index
  local num_tags = #Utils.myscreen().tags
  local ok = (direction == "next" and index < num_tags)
  or (direction == "prev" and index > 1)
  local new_index

  if ok then
    if direction == "next" then
      new_index = index + 1
    elseif direction == "prev" then
      new_index = index - 1
    end

    s_index = new_index

    local new_tag = Utils.myscreen().tags[new_index]

    if sticky then
      if client.focus and client.focus.screen == Utils.myscreen() then
        client.focus:move_to_tag(new_tag)
      end
    end

    new_tag:view_only()
  end
end

function Utils.next_tag(sticky)
  tag_next_lock.trigger(sticky)
end

function Utils.prev_tag(sticky)
  tag_prev_lock.trigger(sticky)
end

function Utils.next_tag_all()
  i = Utils.mytag().index + 1

  if i > #Utils.myscreen().tags then
    i = #Utils.myscreen().tags
  end

  for s in screen do
    Utils.goto_tag(s, i)
  end
end

function Utils.prev_tag_all()
  i = Utils.mytag().index - 1

  if i < 1 then
    i = 1
  end

  for s in screen do
    Utils.goto_tag(s, i)
  end
end

function Utils.goto_tag(s, i)
  local tag = s.tags[i]

  if tag then
    tag:view_only()
  end
end

function Utils.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function Utils.show_audio_controls()
  Utils.shellspawn("python ~/code/empris/empris.py")
end

function Utils.move_to_tag(t)
  if client.focus then
    client.focus:move_to_tag(t)
    t:view_only()
  end
end

function Utils.auto_suspend(minutes)
  autotimer.start_timer("Suspend", minutes, function()
    Utils.suspend()
  end)
end

function Utils.timer(title, minutes)
  autotimer.start_timer(title, minutes, function()
    Utils.msg(title.." ended")
  end)
end

function Utils.counter(title)
  autotimer.start_counter(title)
end

function Utils.isempty(s)
  return s == nil or s == ""
end

function Utils.highest_in_tag(tag)
  for _, c in ipairs(client.get(tag.screen, true)) do
    if Utils.table_contains(c:tags(), tag) then
      return c
    end
  end
end

function Utils.table_contains(tab, val)
  for index, value in ipairs(tab) do
    if value == val then
      return true
    end
  end

  return false
end

function Utils.fake_input_do(ctrl, shift, key)
  local timer = gears.timer {
    timeout = 0.11
  }

  timer:connect_signal("timeout", function()
    root.fake_input('key_release', "Super_L")
    root.fake_input('key_release', "Super_R")
    root.fake_input('key_release', "Control_L")
    root.fake_input('key_release', "Control_R")
    root.fake_input('key_release', "Shift_L")
    root.fake_input('key_release', "Shift_R")
    root.fake_input('key_release', "Delete")

    if ctrl then
      root.fake_input('key_press', "Control_L")
    end

    if shift then
      root.fake_input('key_press', "Shift_L")
    end

    root.fake_input('key_press', key)
    root.fake_input('key_release', key)

    if ctrl then
      root.fake_input('key_release', "Control_L")
    end

    if shift then
      root.fake_input('key_release', "Shift_L")
    end

    timer:stop()
  end)

  timer:start()
end

function Utils.browser_hotcorner()
  for _, c in ipairs(client.get()) do
    if c.xhotcorner == "1_top_left" and c.screen.index == 1 then
      Utils.focus(c)

      if c.first_tag ~= Utils.mytag() then
        c.first_tag:view_only()
        return
      end

      Utils.fake_input_do(true, false, "space")
      return
    end
  end
end

function Utils.browser_hotcorner_next()
  for _, c in ipairs(client.get()) do
    if c.xhotcorner == "1_top_left" and c.screen.index == 1 then
      Utils.focus(c)

      if c.first_tag ~= Utils.mytag() then
        c.first_tag:view_only()
        return
      end

      Utils.fake_input_do(true, false, "Tab")
      return
    end
  end
end

function Utils.browser_hotcorner_prev()
  for _, c in ipairs(client.get()) do
    if c.xhotcorner == "1_top_left" and c.screen.index == 1 then
      Utils.focus(c)

      if c.first_tag ~= Utils.mytag() then
        c.first_tag:view_only()
        return
      end

      Utils.fake_input_do(true, true, "Tab")
      return
    end
  end
end

function Utils.minimize(c)
  c:activate {context = "tasklist", action = "toggle_minimization"}
end

function Utils.reset_rules(c)
  Rules.reset_rules(c)
  Rules.check_title_rules(c, true)
end

function Utils.smart_button(c)
  local c = mouse.object_under_pointer()

  if not c then
    return
  end

  if c.instance == "dolphin" then
    Utils.focus(c)
    Utils.show_commands()
    return
  end

  if c.instance == "tilix" then
    Utils.focus(c)
    Utils.show_commands()
    return
  end

  if c.xclient then
    if c.xtiled then
      Utils.reset_rules(c)
    else
      Utils.minimize(c)
    end
  end
end

function Utils.show_commands()
  Utils.home_bin("commands")
end