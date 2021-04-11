local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local instances = {}
local menupanel = {}

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function beep(txt)
  awful.util.spawn_with_shell("play -q -n synth 0.1 sin 880", false)
end

function focus_button(instance, btn)
  btn.bg = beautiful.tasklist_bg_focus
  btn.fg = beautiful.tasklist_fg_focus
  if instance.args.speak then speak(btn.xtext) end
  instance.grabber_index = btn.xindex
  reset_confirm_charges(instance)
end

function unfocus_button(instance, btn)
  btn.fg = nil
  btn.bg = nil
end

function unfocus_except(instance, index)
  for i, btn in ipairs(instance.buttons) do
    if i == index then
      focus_button(instance, btn)
    else
      unfocus_button(instance, btn)
    end
  end
end

function hide_all(instance)
  for i, insta in ipairs(instances) do
    if insta.visible then
      insta.hide()
    end
  end
end

function before_action(instance, mode)
  if mode == 1 then
    instance.hide()
  else
    beep()
  end
end

function action(instance, item, mode)
  if mode == 1 or mode == 2 then
    if item.action ~= nil then 
      if item.needs_confirm then
        if item.confirm_charge < 1 then
          item.confirm_charge = item.confirm_charge + 1
        else
          reset_confirm_charges(instance)
          before_action(instance, mode)
          item.action()
        end
      else
        before_action(instance, mode)
        item.action()
      end
    end
  end
end

function reset_confirm_charges(instance)
  for i, item in ipairs(instance.args.items) do
    item.confirm_charge = 0
  end
end

function prepare_button(instance, widgt, index)
  local button = wibox.widget {
    widgt,
    widget = wibox.container.background,
    border_width = 1,
    border_color = beautiful.tasklist_fg_normal
  }

  button.xtext = widgt.text
  button.xindex = index

  button:connect_signal("mouse::enter", function(btn)
    unfocus_except(instance, index)
  end)

  button:connect_signal("mouse::leave", function(btn)
    unfocus_button(instance, btn)
  end)

  return button
end

function menupanel.create(args)
  if args.placement == nil then
    args.placement = "bottom"
  end

  if args.speak == nil then
    args.speak = false
  end

  if args.on_esc == nil then
    args.on_esc = function() end
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
        action(instance, instance.args.items[instance.grabber_index], 1)
      end},
      {{"Shift"}, 'Return', function()
        action(instance, instance.args.items[instance.grabber_index], 2)
      end},
      {{}, 'Escape', function() 
        instance.hide()
        instance.args.on_esc()
      end},
      {{"Shift"}, 'Escape', function() 
        hide_all(instance)
      end}
    }
  }

  -- Methods

  function instance.show()
    hide_all(instance)
    instance.screen = awful.screen.focused()
    instance.visible = true
    instance.grabber_index = 1
    reset_confirm_charges(instance)
    unfocus_except(instance, instance.grabber_index)
    instance.keygrabber:start()
  end

  function instance.hide()
    instance.visible = false
    instance.keygrabber:stop()
  end

  -- Items
  
  instance.buttons = {}

  for i, item in ipairs(args.items) do
    if item.needs_confirm == nil then
      item.needs_confirm = false
    end

    item.confirm_charge = 0

    local new_item = wibox.widget {
      text = " "..item.name.." ",
      align = "center",
      widget = wibox.widget.textbox
    }

    new_item:connect_signal("button::press", function(_, _, _, mode)
      action(instance, item, mode)
    end)

    table.insert(instance.buttons, prepare_button(instance, new_item, i))
  end

  -- Setup

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

  table.insert(instances, instance)
  return instance
end

return menupanel