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
  local panel = awful.popup({
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

  panel.args = args

  -- Methods

  function panel.show()
    panel.screen = awful.screen.focused()
    panel.visible = true
    panel.stop_autoclose()
  end

  function panel.hide()
    panel.visible = false
    panel.stop_autoclose()
  end

  function panel.toggle()
    if panel.visible then
      panel.hide()
    else
      panel.show()
    end
  end

  function panel.create_icon(c)
    local icon = wibox.widget{
      text = " "..c.." ",
      widget = wibox.widget.textbox,
    }
  
    icon:connect_signal("button::press", function(a, b, c, button, mods)
      if button == 1 then panel.toggle() end
    end)

    return icon
  end

  function panel.start_autoclose()
    if panel.args.autoclose then
      panel.timeout = gears.timer {
        timeout = panel.args.autoclose_delay,
        autostart = true,
        callback = function()
          panel.hide()
        end
      }
    end
  end

  function panel.stop_autoclose()
    if panel.timeout ~= nil then
      panel.timeout:stop()
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
        panel.toggle()
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
          panel.hide()
        end
      end
    end)

    table.insert(items, prepare_button(new_item, args))
  end

  -- Setup

  panel:connect_signal("mouse::leave", function(a, b, c, button, mods)
    if panel.visible then
      panel.start_autoclose()
    end
  end)

  panel:connect_signal("mouse::enter", function(a, b, c, button, mods)
    panel.stop_autoclose()
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

  panel:setup {
    layout = wibox.layout.align.horizontal,
    left,
    middle,
    right,
  }

  return panel
end

return menupanel