pcall(require, "luarocks.loader")
require("awful.autofocus")
local ruled = require("ruled")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
--
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local datetime = require("madwidgets/datetime/datetime")
local bindings = require("modules/bindings")
require("modules/autostart")
--

if awesome.startup_errors then
  naughty.notify({
    preset = naughty.config.presets.critical,
    title = "Oops, there were errors during startup!",
    text = awesome.startup_errors
  })
end

do
  local in_error = false
  awesome.connect_signal("debug::error", function(err)
    if in_error then
      return
    end
    in_error = true

    naughty.notify({
      preset = naughty.config.presets.critical,
      title = "Oops, an error happened!",
      text = tostring(err)
    })
    in_error = false
  end)
end

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local theme = beautiful.get()
theme.font = "sans 11"
beautiful.init(theme)

local color_1 = "#3f3f3f"
local color_white = "#ffffff"

beautiful.wibar_height = 25
beautiful.tasklist_bg_focus = color_1
beautiful.tasklist_fg_focus = color_white
beautiful.tasklist_bg_minimize = ""
beautiful.taglist_bg_focus = color_1
beautiful.notification_font = "Noto Sans 18px"
beautiful.notification_icon_size = 100
awful.mouse.snap.default_distance = 25

local menupanels = require("modules/menupanels")

awful.layout.layouts = {
  awful.layout.suit.floating
}

local function set_wallpaper(s)
  if beautiful.wallpaper then
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
      wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)
  end
end

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  set_wallpaper(s)

  local num_tags = 4
  local tags = {}

  for i = 1, num_tags, 1 do 
    table.insert(tags, ""..i.."")
  end

  awful.tag(tags, s, awful.layout.layouts[1])

  s.mytasklist = awful.widget.tasklist {
    screen = s,
    buttons = bindings.tasklist_buttons,
    filter = function() return true end, 
    source = function()
      local result = {}
      local unindexed = {}
      
      for _, c in pairs(client.get()) do
        if awful.widget.tasklist.filter.currenttags(c, s) then
          if c.xindex > 0 then
            table.insert(result, c)
          else
            table.insert(unindexed, c)
          end
        end
      end

      table.sort(result, function(a, b) return a.xindex < b.xindex end)
      for _, c in pairs(unindexed) do table.insert(result, c) end
      return result
    end
  }

  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = bindings.taglist_buttons
  }

  s.mainpanel = awful.wibar({
    ontop = false,
    position = "bottom",
    screen = s
  })

  local left
  local right

  left = {
    layout = wibox.layout.fixed.horizontal,
    menupanels.main.create_icon("❇"),
    s.mytaglist,
    wibox.widget.textbox("  "),
  }

  if s.index == 1 then
    local right_layout = wibox.layout.fixed.horizontal()
    
    right = {
      layout = right_layout,
      wibox.widget.textbox("  "),
      wibox.widget.textbox("  "),
      wibox.widget.systray(),
      wibox.widget.textbox("  "),
      volumecontrol.create(),
      wibox.widget.textbox("  "),
      datetime.create({
        on_click = function()
          calendar()
        end,
        on_wheel_up = function()
          increase_volume()
        end,
        on_wheel_down = function()
          decrease_volume()
        end
      }),
      wibox.widget.textbox("  "),
    }
  else
    right = {
      layout = wibox.layout.fixed.horizontal
    }
  end

  s.mainpanel:setup {
    layout = wibox.layout.align.horizontal,
    left,
    s.mytasklist,
    right
  }
end)

root.keys(bindings.globalkeys)

awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = 0,
      border_color = beautiful.border_normal,
      focus = awful.client.focus.filter,
      raise = true,
      keys = bindings.clientkeys,
      buttons = bindings.clientbuttons,
      screen = awful.screen.preferred,
      placement = function(c)
        return awful.placement.centered(c, {honor_workarea = true})
      end,
      xindex = 0
    }
  },
  {
    rule = {class = "Firefox"},
    properties = {
      xindex = 1
    }
  },
  {
    rule = {instance = "code"},
    properties = {
      xindex = 2
    }
  },
  {
    rule = {instance = "lutris"},
    properties = {
      xindex = 3
    }
  },
  {
    rule = {instance = "Steam"},
    properties = {
      xindex = 4
    }
  },
  {
    rule = {instance = "fl64.exe"},
    properties = {
      xindex = 5,
      maximized = true
    }
  },
  {
    rule_any = {
      instance = {"dolphin", "spotify", "clementine", "hexchat", "konsole"},
      class = {"mpv"},
    },
    properties = {
      screen = 2,
      tag = "1",
    }
  }, 
  {
    rule = {instance = "spotify"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 1
    }
  }, 
  {
    rule = {instance = "clementine"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 2
    }
  },
  {
    rule = {instance = "konsole"},
    properties = {
      placement = function(c)
        return awful.placement.top_right(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.4,
      xindex = 3
    }
  },
  {
    rule = {instance = "dolphin"},
    properties = {
      placement = function(c)
        return awful.placement.top_left(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.4,
      xindex = 4,
    }
  },
  {
    rule = {class = "mpv"},
    properties = {
      placement = function(c)
        return awful.placement.bottom_right(c, {honor_workarea = true})
      end,
      width = awful.screen.focused().workarea.width * 0.5,
      height = awful.screen.focused().workarea.height * 0.6,
      xindex = 5
    }
  },
}

client.connect_signal("manage", function(c)
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
end)

function prev_tag()
  awful.screen.focused().tags[
    math.max(1, awful.screen.focused().selected_tags[1].index - 1)
  ]:view_only()
end

function next_tag()
  awful.screen.focused().tags[
    math.min(#awful.screen.focused().tags, awful.screen.focused().selected_tags[1].index + 1)
  ]:view_only()
end

function prev_client()
  awful.client.focus.history.previous()
  if client.focus then
    client.focus:raise()
  end
end

function maximize(c)
  focus(c)
  c.maximized = not c.maximized
end

function focus(c)
  c.first_tag:view_only()
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
  awful.util.spawn("rofi -modi drun -show drun -show-icons -width 22 -no-click-to-exit", false)
end

function symbolsmenu()
  menupanels.symbols.show()
end

function layoutsmenu()
  menupanels.layouts.show()
end

function dropdown()
  awful.util.spawn("tilix --quake", false)
end

function lockscreen()
  awful.util.spawn_with_shell("i3lock --color=000000")
end

function calendar()
  awful.util.spawn("osmo", false)
end

function typestring(txt)
  awful.util.spawn("xdotool type "..txt, false)
end

function msg(txt)
  naughty.notify({text = " "..txt.." "})
end

function increase_volume()
  volumecontrol.change("increase")
end

function decrease_volume()
  volumecontrol.change("decrease")
end

function apply_layout(mode)
  if mode == "left_right" then
    local counter = 1
    for i, c in ipairs(awful.screen.focused().clients) do
      if counter == 1 then
        snap(c, "vertically", awful.placement.left)
        counter = counter + 1
      elseif counter == 2 then
        snap(c, "vertically", awful.placement.right)
        counter = counter + 1
      end

      if counter > 2 then return end
    end
  elseif mode == "up_down" then
    local counter = 1
    for i, c in ipairs(awful.screen.focused().clients) do
      if counter == 1 then
        snap(c, "horizontally", awful.placement.top)
        counter = counter + 1
      elseif counter == 2 then
        snap(c, "horizontally", awful.placement.bottom)
        counter = counter + 1
      end
  
      if counter > 2 then return end
    end
  end
end

confirm_func = function() end

function needs_confirm(func)
  confirm_func = func
  menupanels.confirm.show()
end

function exec_confirm()
  confirm_func()
end

ruled.notification.connect_signal('request::rules', function()
  ruled.notification.append_rule {
    rule = {},
    properties = {
      position = "bottom_right",
      implicit_timeout = 3,
      never_timeout = false
    }
  }
end)

function launch_1()
  awful.util.spawn("firefox", false)
  awful.util.spawn("code", false)
  awful.util.spawn("steam", false)
  awful.util.spawn("lutris", false)
end

function launch_2()
  awful.util.spawn("dolphin", false)
  awful.util.spawn("konsole -e bpytop", false)
  awful.util.spawn("clementine", false)
  awful.util.spawn("spotify", false)
end