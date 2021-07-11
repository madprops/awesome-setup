local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local multibutton = require("madwidgets/multibutton/multibutton")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local datetime = require("madwidgets/datetime/datetime")
local cpu = require("madwidgets/cpu/cpu")
local bindings = require("modules/bindings")

awful.screen.connect_for_each_screen(function(s)
  awful.tag({"1"}, s, awful.layout.suit.floating)
  gears.wallpaper.set("#000000")

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
      end,
      on_wheel_down = function()
        minimize_all()
      end,
      on_wheel_up = function()
        unminimize_all()
      end,
    }),
    cpu.create(),
    space(),
  }

  right = {
    layout = wibox.layout.fixed.horizontal(),
    space(),
    wibox.widget.systray(),
    space(),
    volumecontrol.create(),
    space(),
    datetime.create({
      format = "%a-%d-%b %H:%M %P ",
      on_click = function()
        calendar()
      end,
      on_wheel_down = function()
        decrease_volume()
      end,
      on_wheel_up = function()
        increase_volume()
      end,
    })
  }

  s.mainpanel:setup {
    layout = wibox.layout.align.horizontal,
    left,
    s.mytasklist,
    right
  }
end)

volumecontrol.refresh()