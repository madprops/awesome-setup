require("awful.autofocus")
local ruled = require("ruled")
local gears = require("gears")
local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
--
local hotcorner = require("madwidgets/hotcorner/hotcorner")
local multibutton = require("madwidgets/multibutton/multibutton")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local datetime = require("madwidgets/datetime/datetime")
local bindings = require("modules/bindings")
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

function msg(txt)
  naughty.notify({text = " "..tostring(txt).." "})
end

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local theme = beautiful.get()
theme.font = "sans 11"
beautiful.init(theme)

local color_white = "#ffffff"
local font_color = "#a8a8a8"
local bg_color = "#222222"
local highlight_color = "#3f3f3f"

beautiful.wibar_height = 25
beautiful.tasklist_fg_normal = font_color
beautiful.tasklist_bg_normal = bg_color
beautiful.tasklist_fg_focus = color_white
beautiful.tasklist_bg_focus = highlight_color
beautiful.tasklist_fg_minimize = font_color
beautiful.tasklist_bg_minimize = bg_color
beautiful.taglist_bg_focus = highlight_color
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

local corner_1

screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
  if s.index == 2 then
    corner_1 = hotcorner.create({
      screen = s,
      placement = awful.placement.top_right,
      action = function()
        next_non_empty_tag()
      end
    })
  end

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
    end,
    widget_template = {
      {
          {
              {
                  {
                    id = 'icon_role',
                    widget = wibox.widget.imagebox,
                  },
                  left = 0,
                  right = 5,
                  widget  = wibox.container.margin,
              },
              {
                id = 'text_role',
                widget = wibox.widget.textbox,
              },
              layout = wibox.layout.fixed.horizontal,
          },
          left  = 2,
          right = 2,
          widget = wibox.container.margin
      },
      id = 'background_role',
      widget = wibox.container.background,
      create_callback = function(self, c, _, _)
        awful.tooltip{
          objects = { self },
          timer_function = function()
            return c.name
          end,
          delay_show = 0.8
        }
      end
    }
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
    multibutton.create({
      text = " ❇ ",
      on_click = function(btn) 
        menupanels.main.show() 
      end,
      on_middle_click = function(btn)
        stop_all_music()
        lockscreen()
      end,
      on_right_click = function(btn)
        dropdown()
      end,
      on_wheel_up = function(btn)
        prev_tag()
      end,
      on_wheel_down = function(btn)
        next_tag()
      end,
    }),
    s.mytaglist,
    wibox.widget.textbox("  "),
  }

  if s.index == 1 then
    right = {
      layout = wibox.layout.fixed.horizontal(),
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
      wibox.widget.textbox("  ")
    }
  else
    right = {
      layout = wibox.layout.fixed.horizontal(),
      wibox.widget.textbox("  "),
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
      wibox.widget.textbox("  ")
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

local cairo = require("lgi").cairo
local default_icon = os.getenv("HOME") .. "/.config/awesome/default_icon.png"

client.connect_signal("manage", function(c)
  if not awesome.startup then
    awful.client.setslave(c)
  end

  if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
    awful.placement.no_offscreen(c)
  end
  
  awful.spawn.easy_async_with_shell("sleep 0.6", function()
    if c and c.valid and not c.icon then
      local s = gears.surface(default_icon)
      local img = cairo.ImageSurface.create(cairo.Format.ARGB32, s:get_width(), s:get_height())
      local cr = cairo.Context(img)
      cr:set_source_surface(s, 0, 0)
      cr:paint()
      c.icon = img._native
    end
  end)
end)

function prev_tag()
  local s = awful.screen.focused()
  s.tags[math.max(1, s.selected_tags[1].index - 1)]:view_only()
end

function next_tag()
  local s = awful.screen.focused()
  s.tags[math.min(#s.tags, s.selected_tags[1].index + 1)]:view_only()
end

function next_non_empty_tag()
  local tags = awful.screen.focused().tags
  local ci = awful.screen.focused().selected_tags[1].index

  for i, t in ipairs(tags) do
    if i > ci then
      if #t:clients() > 0 then t:view_only() return end
    end
  end

  if ci > 1 then tags[1]:view_only() end
end

function screen_or_preferred(n)
  if #screen >= n then 
    return n 
  else 
    return awful.screen.preferred
  end
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

function screenshot()
  awful.util.spawn("flameshot gui -p /home/yo/Downloads/pics/pics1", false)
end

function media(action)
  awful.util.spawn("playerctl -p spotify " ..action, false)
end

function randstring()
  awful.util.spawn("/home/yo/scripts/randword.sh", false)
end

function randword()
  awful.util.spawn("/home/yo/scripts/randword.sh word", false)
end

function show_menupanel()
  menupanels.main.show()
end

function dropdown()
  awful.util.spawn("tilix --quake", false)
end

function stop_all_music()
  awful.util.spawn_with_shell("playerctl -p firefox pause")
  awful.util.spawn_with_shell("playerctl -p strawberry pause")
  awful.util.spawn_with_shell("playerctl -p vlc pause")
end

function lockscreen(suspend)
  local s = ""

  if suspend then
    s = "systemctl suspend; "
  end

  awful.util.spawn_with_shell(s.."i3lock --color=000000 -n")
end

local logpath = "/home/yo/.config/clickthing/clicks.txt"

function add2log(name)
  local txt = name.." "..os.date("%c")
  awful.util.spawn_with_shell("echo -e '"..txt.."' | cat - "..logpath.." | sponge "..logpath)
end

function showlog(name)
  awful.util.spawn_with_shell("kwrite "..logpath)
end

function calendar()
  awful.util.spawn("osmo", false)
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

ruled.notification.connect_signal("request::rules", function()
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
  awful.util.spawn("vivaldi-stable", false)
  awful.util.spawn("code", false)
  awful.util.spawn("dolphin", false)
  awful.util.spawn("strawberry", false)
  awful.util.spawn("hexchat", false)
  awful.util.spawn("kdeconnect-indicator")
  awful.util.spawn("onboard")
end

function launch_2()
  msg("Starting PulseEffects")
  awful.util.spawn("pulseeffects --gapplication-service")
end

if #screen >= 2 then
  awful.layout.set(awful.layout.suit.tile, screen[2].tags[2])
end

require("modules/rules")
require("modules/autostart")
volumecontrol.refresh()