local awful = require("awful")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")
local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")
local autotimer = require("madwidgets/autotimer/autotimer")
local tagview = require("madwidgets/tagview/tagview")

autotimer.create({
  left = " ",
  fontcolor = Globals.niceblue,
  separator = "|", separator_color = Globals.nicedark
})

local function sysmonitor_widget(mode)
  local args = {}
  args.mode = mode

  args.on_wheel_down = function()
    Utils.decrease_volume()
  end

  args.on_wheel_up = function()
    Utils.increase_volume()
  end

  args.left_color = Globals.nicedark

  if mode == "cpu" then
    args.left = " "
    args.right = " | "
    args.right_color = Globals.nicedark
    args.on_click = function()
      Utils.system_monitor()
    end
  elseif mode == "ram" then
    args.right = " | "
    args.right_color = Globals.nicedark
    args.on_click = function()
      Utils.system_monitor()
    end
  elseif mode == "tmp" then
    args.on_click = function()
      Utils.system_monitor_temp()
    end
  elseif mode == "net_download" then
    args.left = " "..Globals.star.." "
    args.left_color = Globals.niceblue
    args.right = " | "
    args.right_color = Globals.nicedark
    args.on_click = function()
      Utils.network_monitor()
    end
  elseif mode == "net_upload" then
    args.on_click = function()
      Utils.network_monitor()
    end
  end

  return sysmonitor.create(args)
end

awful.screen.connect_for_each_screen(function(s)
  awful.tag({ "1", "2", "3", "4", "5"}, s, awful.layout.suit.floating)

  s.mytaglist = awful.widget.taglist {
    screen  = s,
    filter  = awful.widget.taglist.filter.all,
    buttons = {
      awful.button({ }, 1, function(t) t:view_only() end),
      awful.button({ }, 3, function(t) Utils.move_to_tag(t) end)
    }
  }

  s.mytasklist = awful.widget.tasklist {
    screen = s,
    buttons = Bindings.tasklist_buttons,
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
                  top = 3,
                  bottom = 3,
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
  systray:set_screen(screen[Globals.primary_screen])
  local systray_container = wibox.layout.margin(systray, 3, 3, 3, 3)

  left = {
    layout = wibox.layout.fixed.horizontal,
    multibutton.create({
      text = " "..Globals.flower.." ",
      on_click = function()
        Utils.show_menupanel("mouse")
      end,
      on_middle_click = function()
        Utils.stop_all_players()
        Utils.lockscreen()
      end
    }),
    s.mytaglist,
    Utils.space()
  }

  if s.index == Globals.primary_screen then
    -- hotcorner.create({
    --   screen = s,
    --   placement = "top_left",
    --   on_click = function()
    --     Utils.corner_click()
    --   end
    -- })

    right = {
      layout = wibox.layout.fixed.horizontal(),
      Utils.space(),
      systray_container,
      sysmonitor_widget("cpu"),
      sysmonitor_widget("ram"),
      sysmonitor_widget("tmp"),
      sysmonitor_widget("net_download"),
      sysmonitor_widget("net_upload"),
      Globals.volumecontrol.create({
        left = " "..Globals.star.." ",
        right = " "..Globals.star.." ",
        left_color = Globals.niceblue,
        right_color = Globals.niceblue,
        mutecolor = Globals.nicedark,
        maxcolor = Globals.nicegreen,
        on_click = function() Utils.show_audio_controls() end
      }),
      multibutton.create({
        widget = wibox.widget.textclock("%a-%d-%b %I:%M:%S %P", 1),
        on_click = function()
          Utils.calendar()
        end,
        on_wheel_down = function()
          Utils.decrease_volume()
        end,
        on_wheel_up = function()
          Utils.increase_volume()
        end,
        right = " "
      })
    }
  else
    right = {
      layout = wibox.layout.fixed.horizontal(),
      autotimer
    }
  end

  s.mywibar:setup {
    layout = wibox.layout.align.horizontal,
    left,
    s.mytasklist,
    right
  }

  tagview.create({
    screen = s
  })
end)

tagview.setup()