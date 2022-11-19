local awful = require("awful")
local wibox = require("wibox")
local overlay = require("madwidgets/overlay/overlay")
local utils = require("madwidgets/utils")

local tagview = {}
local instances = {}

function tagview.setup()
  tag.connect_signal("property::selected", function(t)
    if not t.selected then
      return
    end

    for _, instance in ipairs(instances) do  
      if instance.args.screen == t.screen then
        local num_tags = #instance.args.screen.tags
        local index = instance.args.screen.selected_tag.index
        local s = ""
      
        for i = 1, num_tags do
          if i == index then
            s = s .. index
          else
            s = s .. "_"
          end
      
          if i < num_tags then
            s = s .. " "
          end
        end 
      
        instance.widget.show("Desktop: " .. s)
      end
    end    
  end)
end

function tagview.create(args)
  local instance = {}
  args.overlay_color = args.overlay_color or "#2B303B"
  args.textbox_bgcolor = args.textbox_bgcolor or "#394753"
  instance.args = args

  local tsk = awful.widget.tasklist {
    screen = args.screen,
    filter = awful.widget.tasklist.filter.currenttags,
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
    }, 
    style = {
      bg_normal = args.overlay_color,
      bg_focus = args.overlay_color,
      bg_minimize = args.overlay_color,
      shape_border_color = args.overlay_color,
      shape_border_color_focus = args.overlay_color,
      font = "monospace 14"
    }
  }
  
  local cont = wibox.widget {
    tsk,
    widget = wibox.container.margin,
    forced_height = 60,
    forced_width = 440,
    left = 5,
    right = 5,
    top = 14,
    bottom = 14
  }
  
  instance.widget = overlay.create({
    screen = args.screen,
    widget = cont,
    bgcolor = args.overlay_color,
    textbox_bgcolor = args.textbox_bgcolor,
    height = 50
  }) 
  
  table.insert(instances, instance)
  return instance
end

return tagview