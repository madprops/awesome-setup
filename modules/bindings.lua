local gears = require("gears")
local awful = require("awful")

-- https://github.com/blueyed/awesome-cyclefocus
local cyclefocus = require("cyclefocus")

local bindings = {}
local altkey = "Mod1"
local modkey = "Mod4"

bindings.globalkeys = gears.table.join(
  awful.key({modkey, "Control"}, "BackSpace", awesome.restart), 
  awful.key({modkey, "Shift"}, "q", awesome.quit), 

  awful.key {
    modifiers = { modkey },
    keygroup = "numrow",
    on_press = function (index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end,
  },

  awful.key {
    modifiers = {modkey, "Shift"},
    keygroup = "numrow",
    on_press = function(index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
          tag:view_only()
        end
      end
    end
  },

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

  awful.key({}, "Pause", function()
    awful.util.spawn("/home/yo/scripts/randword.sh", false)
  end),

  awful.key({"Control"}, "Pause", function()
    awful.util.spawn("/home/yo/scripts/randword.sh word", false)
  end),

  awful.key({}, "Print", function()
    awful.util.spawn("flameshot gui -p /home/yo/Downloads/pics/pics1", false)
  end), 

  awful.key({}, "XF86AudioPlay", function()
    awful.util.spawn("playerctl -p spotify play-pause", false)
  end),

  awful.key({}, "XF86AudioNext", function()
    awful.util.spawn("playerctl -p spotify next", false)
  end), 

  awful.key({}, "XF86AudioPrev", function()
    awful.util.spawn("playerctl -p spotify previous", false)
  end), 

  awful.key({"Control"}, "XF86AudioPlay", function()
    awful.util.spawn("playerctl -p clementine play-pause", false)
  end), 

  awful.key({"Control"}, "XF86AudioNext", function()
    awful.util.spawn("playerctl -p clementine next", false)
  end), 

  awful.key({"Control"}, "XF86AudioPrev", function()
    awful.util.spawn("playerctl -p clementine previous", false)
  end), 

  awful.key({}, "XF86AudioRaiseVolume", function()
    increase_volume()
  end), 

  awful.key({}, "XF86AudioLowerVolume", function()
    decrease_volume()
  end), 

  awful.key({modkey}, "Delete", function(c)
    awful.util.spawn("/home/yo/scripts/closer.sh", false)
  end), 

  awful.key({modkey}, "#79", function()
    snap(client.focus, "corner", awful.placement.top_left)
  end), 

  awful.key({modkey}, "#80", function()
    snap(client.focus, "horizontally", awful.placement.top)
  end), 

  awful.key({modkey}, "#81", function()
    snap(client.focus, "corner", awful.placement.top_right)
  end), 

  awful.key({modkey}, "#83", function()
    snap(client.focus, "vertically", awful.placement.left)
  end), 

  awful.key({modkey}, "#84", function()
    maximize(client.focus)
  end), 

  awful.key({modkey}, "#85", function()
    snap(client.focus, "vertically", awful.placement.right)
  end), 

  awful.key({modkey}, "#87", function()
    snap(client.focus, "corner", awful.placement.bottom_left)
  end), 

  awful.key({modkey}, "#88", function()
    snap(client.focus, "horizontally", awful.placement.bottom)
  end), 

  awful.key({modkey}, "#89", function()
    snap(client.focus, "corner", awful.placement.bottom_right)
  end), 

  awful.key({modkey, "Control"}, "1", function()
    launch_1()
  end),

  awful.key({modkey, "Control"}, "2", function()
    launch_2()
  end)
)

bindings.clientkeys = gears.table.join(
  awful.key({modkey}, "f", function(c)
    c.fullscreen = not c.fullscreen
    c:raise()
  end),

  awful.key({altkey}, "F4", function(c)
    close(c)
  end), 

  awful.key({modkey}, "\\", function(c)
    c:move_to_screen()
  end), 

  awful.key({modkey}, "BackSpace", function(c)
    maximize(c)
  end),
  
  cyclefocus.key({altkey}, "Tab", {
    cycle_filters = { cyclefocus.filters.same_screen, cyclefocus.filters.common_tag },
    keys = {'Tab', 'ISO_Left_Tab'}
  })
)

bindings.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    focus(c)
  end), 

  awful.button({modkey}, 1, function(c)
    focus(c)
    c.maximized = false
    awful.mouse.client.move(c)
  end), 

  awful.button({modkey}, 3, function(c)
    focus(c)
    c.maximized = false
    awful.mouse.client.resize(c)
  end)
)

bindings.tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    c:activate { context = "tasklist", action = "toggle_minimization" }
  end), 

  awful.button({}, 3, function(c)
    maximize(c)
  end), 

  awful.button({modkey}, 4, function(c)
    awful.client.swap.byidx(-1, c)
  end), 

  awful.button({modkey}, 5, function(c)
    awful.client.swap.byidx(1, c)
  end)
)

bindings.taglist_buttons = {
  awful.button({ }, 1, function(t)
    t:view_only()
  end),
  awful.button({ modkey }, 1, function(t)
    if client.focus then
      client.focus:move_to_tag(t)
    end
  end),
  awful.button({ }, 3, awful.tag.viewtoggle),
  awful.button({ modkey }, 3, function(t)
    if client.focus then
      client.focus:toggle_tag(t)
    end
  end),
  awful.button({ }, 4, function() prev_tag() end),
  awful.button({ }, 5, function() next_tag() end),
}

return bindings
