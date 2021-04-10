local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")

local menupanel = {}

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function focus_button(btn, args)
  btn.bg = beautiful.tasklist_bg_focus
  btn.fg = beautiful.tasklist_fg_focus
  if args.speak then speak(btn.text) end
end

function unfocus_button(btn, args)
  btn.fg = nil
  btn.bg = nil
end

function unfocus_except(instance, index)
  for i, btn in ipairs(instance.buttons) do
    if i == index then
      focus_button(btn, instance.args)
    else
      unfocus_button(btn, instance.args)
    end
  end
end

function prepare_button(instance, widgt, index)
  local button = wibox.widget {
    widgt,
    widget = wibox.container.background,
    border_width = 1,
    border_color = beautiful.tasklist_fg_normal
  }

  button.text = widgt.text

  button:connect_signal("mouse::enter", function(btn)
    unfocus_except(instance, index)
  end)

  button:connect_signal("mouse::leave", function(btn)
    unfocus_button(btn, instance.args)
  end)

  return button
end

function menupanel.create(args)
  if args.placement == nil then
    args.placement = "bottom"
  end

  if args.autoclose == nil then
    args.autoclose = true
  end

  if args.autoclose_delay == nil then
    args.autoclose_delay = 1
  end

  if args.speak == nil then
    args.speak = false
  end

  local instance = awful.popup({
    placement = args.placement,
    ontop = true,
    visible = false,
    border_width = 0,
    minimum_height = beautiful.wibar_height,
    minimum_width = awful.screen.focused().geometry.width,
    widget = wibox.widget.background,
    bg = beautiful.tasklist_bg_normal,
    fg = beautiful.tasklist_fg_normal,
  })

  instance.args = args
  instance.grabber_index = 1

  instance.keygrabber = awful.keygrabber {
    keybindings = {
      {{}, 'Left', function()
        if instance.grabber_index > 1 then
          instance.grabber_index = instance.grabber_index - 1
          unfocus_except(instance, instance.grabber_index)
        end
      end},
      {{}, 'Right', function()
        if instance.grabber_index < #instance.args.items then
          instance.grabber_index = instance.grabber_index + 1
          unfocus_except(instance, instance.grabber_index)
        end
      end},
      {{}, 'Return', function()
        instance.action(instance.args.items[instance.grabber_index], 1)
      end},
      {{"Shift"}, 'Return', function()
        instance.action(instance.args.items[instance.grabber_index], 2)
      end},
      {{}, 'Escape', function() instance.hide() end}
    }
  }

  -- Methods

  function instance.action(item, mode)
    if mode == 1 or mode == 2 then
      if item.action ~= nil then
        if mode == 1 then
          instance.hide()
        end
  
        if item.needs_confirm then
          local confirm = menupanel.create({
            placement = instance.args.placement,
            autoclose = instance.args.autoclose,
            autoclose_delay = instance.args.autoclose_delay,
            speak = instance.args.speak,
            items = {
              {
                name = "Confirm "..item.name,
                action = item.action,
              },
            },
          })
  
          confirm.show()
        else
          item.action()
        end
      end
    end
  end

  function instance.show()
    instance.screen = awful.screen.focused()
    instance.visible = true
    instance.stop_autoclose()
    instance.grabber_index = 1
    unfocus_except(instance, instance.grabber_index)
    instance.keygrabber:start()
  end

  function instance.hide()
    instance.visible = false
    instance.stop_autoclose()
    instance.keygrabber:stop()
  end

  function instance.toggle()
    if instance.visible then
      instance.hide()
    else
      instance.show()
    end
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
  
  instance.buttons = {}

  for i, item in ipairs(args.items) do
    if item.needs_confirm == nil then
      item.needs_confirm = false
    end

    local new_item = wibox.widget {
      text = " "..item.name.." ",
      align = "center",
      widget = wibox.widget.textbox
    }

    new_item:connect_signal("button::press", function(_, _, _, mode)
      instance.action(item, mode)
    end)

    table.insert(instance.buttons, prepare_button(instance, new_item, i))
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
  }

  local middle = wibox.widget {
    layout = wibox.layout.ratio.horizontal,
    table.unpack(instance.buttons)
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