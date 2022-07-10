local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local multibutton = require("madwidgets/multibutton/multibutton")
local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")
local bindings = require("modules/bindings")

local nicegreen = "#99EDC3"
local niceblue = "#9BBCDE"

primary_screen = 1
volumecontrol = require("madwidgets/volumecontrol/volumecontrol")

function sysmonitor_widget(mode, fontcolor)
  local args = {}

  args.mode = mode

  args.on_click = function()
    system_monitor()
  end

  args.on_wheel_down = function()
    decrease_volume()
  end

  args.on_wheel_up = function()
    increase_volume()
  end

  args.fontcolor = fontcolor
  
  args.left = " "
  args.right = " " 

  return sysmonitor.create(args)
end

awful.screen.connect_for_each_screen(function(s)
  awful.tag({ "1", "2", "3", "4" }, s, awful.layout.suit.floating)
  
  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ }, 3, function(t) move_to_tag(t) end),
      awful.button({ }, 4, function(t) prev_tag() end),
      awful.button({ }, 5, function(t) next_tag() end)
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
        if c.screen == s then
          if c.first_tag.index == s.selected_tag.index then
            if c.xindex > 0 then
              table.insert(result, c)
            else
              table.insert(unindexed, c)
            end
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
  
  local systray = wibox.widget.systray()
  systray:set_screen(screen[primary_screen])

  left = {
    layout = wibox.layout.fixed.horizontal,
    multibutton.create({
      text = " ❇ ",
      on_click = function() 
        show_menupanel("mouse")
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
    s.mytaglist,
    space()
  }

  if s.index == primary_screen then    
    right = {
      layout = wibox.layout.fixed.horizontal(),
      space(),
      systray,
      sysmonitor_widget("cpu", nicegreen),
      sysmonitor_widget("ram", nicegreen),
      sysmonitor_widget("tmp", nicegreen),
      sysmonitor_widget("net_download", niceblue),
      sysmonitor_widget("net_upload", niceblue),
      volumecontrol.create({
        left = " ", right = " ",
        on_click = function() show_audio_controls() end
      }),
      multibutton.create({
        widget = wibox.widget.textclock(" %a-%d-%b %I:%M:%S %P ", 1),
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
  else
    right = {
      layout = wibox.layout.fixed.horizontal()
    }
  end

  s.mywibar:setup {
    layout = wibox.layout.align.horizontal,
    left,
    s.mytasklist,
    right
  }
end)

screen.connect_signal("request::wallpaper", function(s)
  awful.wallpaper {
    screen = s,
    widget = {
      {
        image     = beautiful.wallpaper,
        upscale   = true,
        downscale = true,
        widget    = wibox.widget.imagebox,
      },
      valign = "center",
      halign = "center",
      tiled  = false,
      widget = wibox.container.tile,
    }
  }
end)