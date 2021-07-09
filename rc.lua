require("awful.autofocus")
local ruled = require("ruled")
local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local multibutton = require("madwidgets/multibutton/multibutton")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local datetime = require("madwidgets/datetime/datetime")

require("modules/theme")
local bindings = require("modules/bindings")

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

awful.screen.connect_for_each_screen(function(s)
  awful.tag({"1"}, s, awful.layout.suit.floating)

  s.mytasklist = awful.widget.tasklist {
    screen = s,
    buttons = bindings.tasklist_buttons,
    filter = function() return true end, 
    source = function()
      local result = {}
      local unindexed = {}
      
      for _, c in pairs(client.get()) do
        if c.xindex > 0 then
          table.insert(result, c)
        else
          table.insert(unindexed, c)
        end
      end

      table.sort(result, function(a, b) return a.xindex < b.xindex end)
      for _, c in pairs(unindexed) do table.insert(result, c) end
      return result
    end
  }

  s.mainpanel = awful.wibar({
    ontop = false,
    position = "bottom",
    screen = s
  })

  local left
  local right
  local space = "  "

  left = {
    layout = wibox.layout.fixed.horizontal,
    multibutton.create({
      text = " ❇ ",
      on_click = function() 
        show_main_menu()
      end,
      on_middle_click = function()
        stop_all_players()
        lockscreen()
      end,
      on_right_click = function()
        dropdown()
      end
    }),
    wibox.widget.textbox(space)
  }

  if s.index == 1 then
    right = {
      layout = wibox.layout.fixed.horizontal(),
      wibox.widget.textbox(space),
      wibox.widget.textbox(space),
      wibox.widget.systray(),
      wibox.widget.textbox(space),
      volumecontrol.create({
        text_left = "",
        text_right = ""
      }),
      datetime.create({
        on_click = function()
          calendar()
        end,
        on_wheel_up = function()
          increase_volume()
        end,
        on_wheel_down = function()
          decrease_volume()
        end,
        text_left = space,
        text_right = space
      })
    }
  else
    right = {
      layout = wibox.layout.fixed.horizontal(),
      wibox.widget.textbox(space),
      wibox.widget.textbox(space),
      volumecontrol.create(),
      wibox.widget.textbox(space),
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
      wibox.widget.textbox(space)
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

require("modules/utils")
require("modules/rules")
require("modules/autostart")
volumecontrol.refresh()