Bindings = {}

local gears = require("gears")
local awful = require("awful")
local doubletap = require("madwidgets/doubletap/doubletap")
local altkey = "Mod1"
local modkey = "Mod4"

local closetap = doubletap.create({
  delay = 300,
  lockdelay = 500,
  action = function()
    local c = mouse.object_under_pointer()
    if not c then return end
    if not c.x_keys then return end
    if c.x_util then return end

    if c.kill then
      if c.instance == "Navigator" or c.instance == "code" then
        Utils.focus(c)
        Utils.fake_input_do(true, false, false, "w")
      else
        c:kill()
      end
    end
  end
})

Bindings.globalkeys = gears.table.join(
  awful.key({modkey, "Control"}, "BackSpace", awesome.restart),
  awful.key({modkey, "Shift"}, "q", awesome.quit),

  awful.key {
    modifiers   = { modkey },
    keygroup    = "numrow",
    group       = "tag",
    on_press    = function (index)
      local screen = awful.screen.focused()
      local tag = screen.tags[index]
      if tag then
        tag:view_only()
      end
    end
  },

  awful.key {
    modifiers = { modkey, "Shift" },
    keygroup    = "numrow",
    group       = "tag",
    on_press    = function (index)
      if client.focus then
        local tag = client.focus.screen.tags[index]
        if tag then
          client.focus:move_to_tag(tag)
        end
      end
    end
  },

  awful.key({modkey}, "`", function()
    Utils.show_menupanel("keyboard")
  end),

  awful.key({"Control"}, "`", function()
    Utils.show_clipboard()
  end),

  awful.key({modkey}, "Return", function()
    Utils.prev_client()
  end),

  awful.key({modkey}, "space", function()
    Utils.launcher()
  end),

  awful.key({"Shift"}, "Scroll_Lock", function()
    Dropdowns.start_utils()
  end),

  awful.key({}, "Scroll_Lock", function()
    Dropdowns.toggle("utils")
  end),

  awful.key({modkey}, "l", function()
    Utils.lockscreen()
  end),

  awful.key({"Shift"}, "Pause", function()
    Utils.randstring()
  end),

  awful.key({}, "Pause", function()
    Utils.randword()
  end),

  awful.key({}, "Print", function()
    Utils.screenshot()
  end),

  awful.key({"Control"}, "Print", function()
    Utils.screenshot_window()
  end),

  awful.key({"Control", "Shift"}, "Print", function()
    Utils.screenshot_screen()
  end),

  awful.key({}, "XF86AudioRaiseVolume", function()
    Utils.increase_volume(true)
  end),

  awful.key({}, "XF86AudioLowerVolume", function()
    Utils.decrease_volume(true)
  end),

  awful.key({modkey, "Shift"}, "Delete", function()
    if mouse.coords().y <= 25 then
      Dropdowns.toggle("utils")
      return
    end

    closetap.trigger()
  end),

  awful.key({modkey, "Shift", "Control"}, "Delete", function()
    if mouse.coords().y <= 25 then
      Dropdowns.toggle("gpt")
    end
  end),

  awful.key({modkey, "Control"}, "space", function()
    Utils.smart_button()
  end),

  awful.key({modkey, "Shift", "Control"}, "space", function()
    Utils.show_audio_controls()
  end),

  awful.key({altkey}, "Tab", function()
    Utils.altab()
  end),

  awful.key({modkey}, "Left", function()
    Utils.prev_tag()
  end),

  awful.key({modkey}, "Right", function()
    Utils.next_tag()
  end),

  awful.key({modkey, "Shift"}, "Left", function()
    Utils.prev_tag_all()
  end),

  awful.key({modkey, "Shift"}, "Right", function()
    Utils.next_tag_all()
  end))

Bindings.clientkeys = gears.table.join(
  awful.key({altkey}, "F4", function(c)
    if not c.x_keys then return end
    Utils.close(c)
  end),

  awful.key({modkey}, "\\", function(c)
    if not c.x_keys then return end
    c:move_to_screen()
  end),

  awful.key({modkey}, "BackSpace", function(c)
    if not c.x_keys then return end
    Utils.maximize(c)
  end),

  awful.key({modkey, "Shift"}, "BackSpace", function(c)
    if not c.x_keys then return end
    Utils.fullscreen(c)
  end),

  awful.key({"Shift"}, "BackSpace", function(c)
    if not c.x_keys then return end
    Rules.reset(c)
  end),

  awful.key({modkey}, "KP_Add", function(c)
    if not c.x_keys then return end
    Utils.grow_in_place(c)
  end),

  awful.key({modkey}, "KP_Subtract", function(c)
    if not c.x_keys then return end
    Utils.shrink_in_place(c)
  end),

  awful.key({modkey}, "#79", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "corner", awful.placement.top_left)
  end),

  awful.key({modkey}, "#80", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "horizontally", awful.placement.top)
  end),

  awful.key({modkey}, "#81", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "corner", awful.placement.top_right)
  end),

  awful.key({modkey}, "#83", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "vertically", awful.placement.left)
  end),

  awful.key({modkey}, "#84", function(c)
    if not c.x_keys then return end
    Utils.maximize(c)
  end),

  awful.key({modkey}, "#85", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "vertically", awful.placement.right)
  end),

  awful.key({modkey}, "#87", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "corner", awful.placement.bottom_left)
  end),

  awful.key({modkey}, "#88", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "horizontally", awful.placement.bottom)
  end),

  awful.key({modkey}, "#89", function(c)
    if not c.x_keys then return end
    Utils.snap(c, "corner", awful.placement.bottom_right)
  end),

  awful.key({modkey, "Control"}, "Left", function()
    Utils.prev_tag(true)
  end),

  awful.key({modkey, "Control"}, "Right", function()
    Utils.next_tag(true)
  end)
)

Bindings.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    Utils.focus(c)
  end),

  awful.button({}, 2, function(c)
    Utils.middle_click(c)
  end),

  awful.button({modkey}, 1, function(c)
    if not c.x_keys then return end
    Utils.focus(c)
    c.maximized = false
    awful.mouse.client.move(c)
  end),

  awful.button({modkey}, 3, function(c)
    if not c.x_keys then return end
    Utils.focus(c)
    c.maximized = false
    awful.mouse.client.resize(c)
  end),

  awful.button({modkey}, 4, function(c)
    if not c.x_keys then return end
    Utils.grow_in_place(c)
  end),

  awful.button({modkey}, 5, function(c)
    if not c.x_keys then return end
    Utils.shrink_in_place(c)
  end)
)

Bindings.tasklist_buttons = gears.table.join(
  awful.button({}, 1, function(c)
    Utils.minimize(c)
    Dropdowns.check_hide(c)
  end),

  awful.button({}, 2, function(c)
    Utils.show_client_title(c)
  end),

  awful.button({}, 3, function(c)
    Utils.show_task_context(c)
  end),

  awful.button({}, 4, function(c)
    if c.x_index ~= 0 then
      Utils.frame_cycle(c, false, true)
    end
  end),

  awful.button({modkey}, 4, function(c)
    awful.client.swap.byidx(-1, c)
  end),

  awful.button({}, 5, function(c)
    if c.x_index ~= 0 then
      Utils.frame_cycle(c, true, true)
    end
  end),

  awful.button({modkey}, 5, function(c)
    awful.client.swap.byidx(1, c)
  end)
)

root.keys(Bindings.globalkeys)