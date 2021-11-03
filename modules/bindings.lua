local gears = require("gears")
local awful = require("awful")
local doubletap = require("madwidgets/doubletap/doubletap")

local bindings = {}
local altkey = "Mod1"
local modkey = "Mod4"

local closetap = doubletap.create({
  delay = 300,
  lockdelay = 1000,
  action = function()
    local c = mouse.object_under_pointer()
    if not c.xkeys then return end
    if c.kill then
      if c.instance == "vivaldi-stable" or 
        c.instance == "Navigator" then
        client.focus = c
        root.fake_input('key_release', "Super_L")
        root.fake_input('key_release', "Super_R")
        root.fake_input('key_release', "Delete")
        root.fake_input('key_press', "Control_L")
        root.fake_input('key_press', "w") 
        root.fake_input('key_release', "w")
        root.fake_input('key_release', "Control_L")
      else
        c:kill()
      end
    end
  end
})

bindings.globalkeys = gears.table.join(
  awful.key({modkey, "Control"}, "BackSpace", awesome.restart), 
  awful.key({modkey, "Shift"}, "q", awesome.quit), 

  awful.key({modkey}, "`", function()
    show_menupanel()
  end),

  awful.key({"Control"}, "`", function()
    show_clipboard()
  end),  

  awful.key({modkey}, "Return", function()
    prev_client()
  end),

  awful.key({modkey}, "space", function()
    launcher()
  end),

  awful.key({}, "Scroll_Lock", function()
    dropdown()
  end),

  awful.key({modkey}, "l", function()
    lockscreen()
  end),

  awful.key({"Shift"}, "Pause", function()
    randstring()
  end),
  
  awful.key({}, "Pause", function()
    randword()
  end),

  awful.key({}, "Print", function()
    screenshot()
  end),

  awful.key({}, "XF86AudioPlay", function()
    media_play_pause()
  end), 

  awful.key({modkey}, "XF86AudioPlay", function()
    media_play_pause(true)
  end), 

  awful.key({}, "XF86AudioNext", function()
    media_next()
  end), 

  awful.key({}, "XF86AudioPrev", function()
    media_prev()
  end), 

  awful.key({}, "XF86AudioRaiseVolume", function()
    increase_volume()
  end), 

  awful.key({}, "XF86AudioLowerVolume", function()
    decrease_volume()
  end), 

  awful.key({modkey, "Control"}, "1", function()
    launch_all()
  end),

  awful.key({modkey}, "Delete", function()
    closetap.trigger()
  end),

  awful.key({altkey}, "Tab", function()
    altab()
  end)
)

bindings.clientkeys = gears.table.join(
  awful.key({altkey}, "F4", function(c)
    if not c.xkeys then return end
    close(c)
  end), 

  awful.key({modkey}, "\\", function(c)
    if not c.xkeys then return end
    c:move_to_screen()
  end), 
  
  awful.key({modkey}, "BackSpace", function(c)
    if not c.xkeys then return end
    maximize(c)
  end),

  awful.key({modkey, "Shift"}, "BackSpace", function(c)
    if not c.xkeys then return end
    fullscreen(c)
  end),

  awful.key({"Shift"}, "BackSpace", function(c)
    if not c.xkeys then return end
    awful.rules.apply(c)
  end),

  awful.key({modkey}, "KP_Add", function(c)
    if not c.xkeys then return end
    grow_in_place(c)
  end),

  awful.key({modkey}, "KP_Subtract", function(c)
    if not c.xkeys then return end
    shrink_in_place(c)
  end),

  awful.key({modkey}, "#79", function(c)
    if not c.xkeys then return end
    snap(c, "corner", awful.placement.top_left)
  end), 

  awful.key({modkey}, "#80", function(c)
    if not c.xkeys then return end
    snap(c, "horizontally", awful.placement.top)
  end), 

  awful.key({modkey}, "#81", function(c)
    if not c.xkeys then return end
    snap(c, "corner", awful.placement.top_right)
  end), 

  awful.key({modkey}, "#83", function(c)
    if not c.xkeys then return end
    snap(c, "vertically", awful.placement.left)
  end), 

  awful.key({modkey}, "#84", function(c)
    if not c.xkeys then return end
    maximize(c)
  end), 

  awful.key({modkey}, "#85", function(c)
    if not c.xkeys then return end
    snap(c, "vertically", awful.placement.right)
  end), 

  awful.key({modkey}, "#87", function(c)
    if not c.xkeys then return end
    snap(c, "corner", awful.placement.bottom_left)
  end), 

  awful.key({modkey}, "#88", function(c)
    if not c.xkeys then return end
    snap(c, "horizontally", awful.placement.bottom)
  end), 

  awful.key({modkey}, "#89", function(c)
    if not c.xkeys then return end
    snap(c, "corner", awful.placement.bottom_right)
  end)  
)

bindings.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    focus(c)
  end), 

  awful.button({modkey}, 1, function(c)
    if not c.xkeys then return end
    focus(c)
    c.maximized = false
    awful.mouse.client.move(c)
  end), 

  awful.button({modkey}, 3, function(c)
    if not c.xkeys then return end
    focus(c)
    c.maximized = false
    awful.mouse.client.resize(c)
  end),

  awful.button({modkey}, 4, function(c)
    if not c.xkeys then return end
    grow_in_place(c)
  end), 
  
  awful.button({modkey}, 5, function(c)
    if not c.xkeys then return end
    shrink_in_place(c)
  end)
)

bindings.tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:activate { context = "tasklist", action = "toggle_minimization" }
  end), 

  awful.button({}, 2, function(c)
    show_client_title(c)
  end), 

  awful.button({}, 3, function(c)
    show_task_context(c)
  end), 

  awful.button({modkey}, 4, function(c)
    awful.client.swap.byidx(-1, c)
  end), 

  awful.button({modkey}, 5, function(c)
    awful.client.swap.byidx(1, c)
  end)
)

root.keys(bindings.globalkeys)
return bindings