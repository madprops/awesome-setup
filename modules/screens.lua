local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local multibutton = require("madwidgets/multibutton/multibutton")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")
local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")
local bindings = require("modules/bindings")

awful.screen.connect_for_each_screen(function(s)
  awful.tag({ "1", "2", "3", "4" }, s, awful.layout.suit.floating)
  gears.wallpaper.maximized(beautiful.wallpaper)

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
      screen  = s,
      filter  = awful.widget.taglist.filter.all,
      buttons = {
        awful.button({ }, 1, function(t) t:view_only() end),
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
        awful.button({ }, 4, function(t) prev_tag() end),
        awful.button({ }, 5, function(t) next_tag() end),
      }
  }  

  s.mytasklist = awful.widget.tasklist {
    screen = s,
    buttons = bindings.tasklist_buttons,
    filter = function() return true end, 
    source = function()
      local result = {}
      local unindexed = {}
      
      for _, c in pairs(client.get()) do
        if c.first_tag.index == s.selected_tag.index then
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
                      id     = 'icon_role',
                      widget = wibox.widget.imagebox,
                  },
                  right = 10,
                  top = 2,
                  bottom = 2,
                  widget  = wibox.container.margin,
              },
              {
                  id     = 'text_role',
                  widget = wibox.widget.textbox,
              },
              layout = wibox.layout.fixed.horizontal,
          },
          left  = 10,
          right = 10,
          widget = wibox.container.margin
      },
      id     = 'background_role',
      widget = wibox.container.background,
    }
  }

  s.mywibar = awful.wibar({
    ontop = true,
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
        next_tag()
      end,
      on_wheel_up = function()
        prev_tag()
      end,
    }),
    s.mytaglist       
  }

  right = {
    layout = wibox.layout.fixed.horizontal(),
    space(),
    wibox.widget.systray(),
    space(),
    sysmonitor.create({
      mode = "cpu",
      on_click = function()
        system_monitor()
      end
    }),
    sysmonitor.create({
      mode = "ram",
      on_click = function()
        system_monitor()
      end
    }),
    sysmonitor.create({
      mode = "tmp",
      on_click = function()
        system_monitor()
      end
    }),     
    space(),
    volumecontrol.create(),
    space(),
    multibutton.create({
      widget = wibox.widget.textclock("%a-%d-%b %I:%M:%S %P ", 1),
      on_click = function()
        calendar()
      end,
      on_wheel_down = function()
        decrease_volume()
      end,
      on_wheel_up = function()
        increase_volume()
      end
    })
  }

  s.mywibar:setup {
    layout = wibox.layout.align.horizontal,
    left,
    s.mytasklist,
    right
  }
end)

volumecontrol.refresh()

client.connect_signal("focus", function(c)
  check_fullscreen(c)
end)

client.connect_signal("property::fullscreen", function(c)
  check_fullscreen(c)
end)
