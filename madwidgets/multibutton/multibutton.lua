local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("madwidgets/utils")

local multibutton = {}

function multibutton.create(args)
  args = args or {}
  args.on_click = args.on_click or function() end
  args.on_click_2 = args.on_click_2 or function() end
  args.on_middle_click = args.on_middle_click or function() end
  args.on_right_click = args.on_right_click or function() end
  args.on_wheel_up = args.on_wheel_up or function() end
  args.on_wheel_down = args.on_wheel_down or function() end
  args.on_mouse_enter = args.on_mouse_enter or function() end
  args.on_mouse_leave = args.on_mouse_leave or function() end
  args.bgcolor = args.bgcolor or beautiful.bg_normal
  args.fontcolor = args.fontcolor or beautiful.fg_normal
  args.left = args.left or ""
  args.right = args.right or ""
  args.left_color = args.left_color or beautiful.fg_normal
  args.right_color = args.right_color or beautiful.fg_normal
  args.opacity = args.opacity or 1

  local instance = {}
  instance.args = args

  local left = {
    layout = wibox.layout.fixed.horizontal,    
    wibox.widget {
      align  = "center",
      valign = "center",
      markup = "<span foreground='"..args.left_color.."'>"..gears.string.xml_escape(args.left).."</span>",
      widget = wibox.widget.textbox
    }
  }

  local right = {
    layout = wibox.layout.fixed.horizontal,    
    wibox.widget {
      align  = "center",
      valign = "center",
      markup = "<span foreground='"..args.right_color.."'>"..gears.string.xml_escape(args.right).."</span>",
      widget = wibox.widget.textbox
    }
  }

  local center

  if args.widget then
    center = {
      layout = wibox.layout.fixed.horizontal,
      args.widget
    }
  elseif args.text then
    center = {
      layout = wibox.layout.fixed.horizontal,
      wibox.widget {
        align  = "center",
        valign = "center",
        text = args.text,
        widget = wibox.widget.textbox
      }      
    }
  else
    return {}
  end

  instance.widget = wibox.widget {
    widget = wibox.container.background,
    bg = args.bgcolor,
    fg = args.fontcolor,
    opacity = args.opacity
  }    

  instance.widget:setup {
    layout = wibox.layout.align.horizontal,
    left,
    center,
    right
  }  
  
  instance.widget:connect_signal("button::press", function(a, b, c, button, mods)
    if button == 1 then
      args.on_click(instance)
    elseif button == 2 then 
      args.on_middle_click(instance)
    elseif button == 3 then 
      args.on_right_click(instance)
    elseif button == 4 then 
      args.on_wheel_up(instance)
    elseif button == 5 then 
      args.on_wheel_down(instance)
    end
  end)

  instance.widget:connect_signal("button::release", function(a, b, c, button, mods)
    if button == 1 then
      args.on_click_2(instance)
    end
  end)
  
  instance.widget:connect_signal("mouse::enter", function()
    args.on_mouse_enter(instance)
  end)

  instance.widget:connect_signal("mouse::leave", function()
    args.on_mouse_leave(instance)  
  end)

  return instance
end

return multibutton