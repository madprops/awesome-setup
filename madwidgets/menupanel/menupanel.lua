local awful = require("awful")
local wibox = require("wibox")
local naughty = require("naughty")
local gears = require("gears")

local menupanel = {}

function msg(txt)
  naughty.notify({text = " "..txt.." "})
end

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function prepare_button(widgt, args)
  local button = wibox.widget {
    widgt,
    widget = wibox.container.background
  }

  button:connect_signal("mouse::enter", function(btn)
    btn.fg = "#ffffff"
    btn.bg = "#333333"
    if args.speak then speak(widgt.text) end
  end)

  button:connect_signal("mouse::leave", function(btn)
    btn.fg = nil
    btn.bg = nil
  end)

  return button
end

function menupanel.create(args)
  local instance = awful.popup({
    placement = args.placement,
    ontop = true,
    visible = false,
    border_width = 0,
    minimum_height = args.height,
    minimum_width = awful.screen.focused().geometry.width,
    widget = wibox.widget.background,
    bg = "#222222",
    fg = "#aaaaaa",
  })

  instance.args = args

  -- Methods

  function instance.show()
    instance.screen = awful.screen.focused()
    instance.visible = true
    instance.stop_autoclose()
  end

  function instance.hide()
    instance.visible = false
    instance.stop_autoclose()
  end

  function instance.toggle()
    if instance.visible then
      instance.hide()
    else
      instance.show()
    end
  end

  function instance.create_icon(c)
    local icon = wibox.widget{
      text = " "..c.." ",
      widget = wibox.widget.textbox,
    }
  
    icon:connect_signal("button::press", function(a, b, c, button, mods)
      if button == 1 then
        instance.toggle()
      elseif button == 2 then
        if args.on_middle_click ~= nil then
          args.on_middle_click()
        end
      elseif button == 3 then
        if args.on_right_click ~= nil then
          args.on_right_click()
        end
      elseif button == 4 then
        if args.on_wheel_up ~= nil then
          args.on_wheel_up()
        end      
      elseif button == 5 then
        if args.on_wheel_down ~= nil then
          args.on_wheel_down()
        end
      end
    end)   

    return icon
  end

  function instance.start_autoclose()
    if instance.args.autoclose then
      instance.timeout = gears.timer {
        timeout = instance.args.autoclose_delay,
        autostart = true,
        callback = function()
          instance.hide()
        end
      }
    end
  end

  function instance.stop_autoclose()
    if instance.timeout ~= nil then
      instance.timeout:stop()
    end
  end

  -- Items
  
  local items = {}
  local hide_button = wibox.widget.textbox("")

  if args.hide_button then
    hide_button = wibox.widget{
      text = " x ",
      widget = wibox.widget.textbox
    }
  
    hide_button:connect_signal("button::press", function(a, b, c, button, mods)
      if button == 1 then
        instance.toggle()
      end
    end)
  
    hide_button = prepare_button(hide_button, args)
  end

  for i, item in ipairs(args.items) do
    local new_item = wibox.widget{
      text = " "..item.name.." ",
      align = "center",
      widget = wibox.widget.textbox
    }

    new_item:connect_signal("button::press", function(a, b, c, button, mods)
      if button == 1 then
        if item.action ~= nil then
          item.action()
        end
        if item.hide_on_click == nil or item.hide_on_click then
          instance.hide()
        end
      end
    end)

    table.insert(items, prepare_button(new_item, args))
  end

  -- Setup

  instance:connect_signal("mouse::leave", function(a, b, c, button, mods)
    if instance.visible then
      instance.start_autoclose()
    end
  end)

  instance:connect_signal("mouse::enter", function(a, b, c, button, mods)
    instance.stop_autoclose()
  end)

  local left = {
    layout = wibox.layout.fixed.horizontal,
    hide_button
  }
  
  local middle = {
    layout = wibox.layout.ratio.horizontal,
    table.unpack(items),
  }
  
  local right = {
    layout = wibox.layout.fixed.horizontal,
  }

  instance:setup {
    layout = wibox.layout.align.horizontal,
    left,
    middle,
    right,
  }

  return instance
end

return menupanel