local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local instances = {}
local menupanel = {}

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function focus_button(instance, btn)
  btn.bg = beautiful.tasklist_bg_focus
  btn.fg = beautiful.tasklist_fg_focus
  if instance.args.speak then speak(btn.textbox.text) end
  instance.grabber_index = btn.xindex
  reset_confirm_charges(instance)
  unfocus_hide_button(instance)
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

function unfocus_all(instance)
  for i, btn in ipairs(instance.buttons) do
    unfocus_button(instance, btn)
  end
  instance.grabber_index = 0
end

function hide_all(instance)
  for i, insta in ipairs(instances) do
    if insta.visible then
      insta.hide()
    end
  end
end

function show_parent(instance)
  if instance.args.parent ~= nil then
    instance.args.parent.show()
  end
end

function hide2(instance)
  instance.hide()
  show_parent(instance)
end

function action(instance, item, mode)
  if mode == 1 or mode == 2 then
    if item.action ~= nil then 
      if item.needs_confirm then
        if item.confirm_charge < 1 then
          item.confirm_charge = item.confirm_charge + 1
          confirm_charge_border(instance.buttons[item.xindex])
        else
          reset_confirm_charges(instance)
          if mode == 1 then instance.hide() end
          item.action()
        end
      else
        if mode == 1 then instance.hide() end
        item.action()
      end
    end
  end
end

function reset_confirm_charges(instance)
  for i, item in ipairs(instance.args.items) do
    item.confirm_charge = 0
    local btn = instance.buttons[i]
    btn.textbox.text = btn.textbox.xoriginaltext
  end
end

function confirm_charge_border(btn)
  btn.textbox.text = "*"..btn.textbox.xoriginaltext.."*"
end

function basic_button(textbox)
  return wibox.widget {
    textbox,
    widget = wibox.container.background,
    border_width = 1,
    border_color = beautiful.tasklist_fg_normal
  }
end

function create_textbox(text)
  return wibox.widget {
    text = text,
    align = "center",
    widget = wibox.widget.textbox
  }
end

function prepare_button(instance, textbox, index)
  local button = basic_button(textbox)

  button.xindex = index
  button.textbox = textbox
  button.textbox.xoriginaltext = textbox.text

  button:connect_signal("mouse::enter", function(btn)
    unfocus_except(instance, index)
  end)

  return button
end

function prepare_hide_button(instance, textbox)
  local button = basic_button(textbox)

  button:connect_signal("mouse::enter", function(btn)
    focus_hide_button(instance)
  end)
    
  button:connect_signal("mouse::leave", function(btn)
    unfocus_hide_button(instance)
  end)

  return button
end

function focus_hide_button(instance)
  instance.hide_button.bg = beautiful.tasklist_bg_focus
  instance.hide_button.fg = beautiful.tasklist_fg_focus
  unfocus_all(instance)
end

function unfocus_hide_button(instance)
  instance.hide_button.bg = nil
  instance.hide_button.fg = nil
end

function menupanel.create(args)
  if args.placement == nil then
    args.placement = "bottom"
  end

  if args.speak == nil then
    args.speak = false
  end

  if args.hide_button == nil then
    args.hide_button = true
  end

  if args.hide_button_placement == nil then
    args.hide_button_placement = "left"
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
        else
          if args.hide_button_placement == "left" then
            focus_hide_button(instance)
          end
        end
      end},
      {{}, 'Right', function()
        if instance.grabber_index < #instance.args.items then
          instance.grabber_index = instance.grabber_index + 1
          unfocus_except(instance, instance.grabber_index)
        else
          if args.hide_button_placement == "right" then
            focus_hide_button(instance)
          end
        end
      end},
      {{}, 'Return', function()
        if instance.grabber_index > 0 then
          action(instance, instance.args.items[instance.grabber_index], 1)
        else
          hide2(instance)
        end
      end},
      {{"Shift"}, 'Return', function()
        if instance.grabber_index > 0 then
          action(instance, instance.args.items[instance.grabber_index], 2)
        else
          hide2(instance)
        end
      end},
      {{}, 'Escape', function() 
        hide2(instance)
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

    item.xindex = i
    item.confirm_charge = 0

    local new_item = create_textbox(item.name)

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

  local right = {
    layout = wibox.layout.fixed.horizontal,
  }

  if args.hide_button then
    local new_item = create_textbox(" x ")

    new_item:connect_signal("button::press", function(_, _, _, mode)
      hide2(instance)
    end)

    instance.hide_button = prepare_hide_button(instance, new_item)

    if args.hide_button_placement == "left" then
      table.insert(left, instance.hide_button)
    elseif args.hide_button_placement == "right" then
      table.insert(right, instance.hide_button)
    end
  end

  instance:setup {
    layout = wibox.layout.align.horizontal,
    left,
    middle,
    right,
  }

  function on_unfocus()
    hide_all(instance)
  end

  -- Hide instances when clicking outside

  button.connect_signal('press', on_unfocus)
  
  instance:connect_signal('mouse::leave', function()
    button.connect_signal('press', on_unfocus)
  end)
  
  instance:connect_signal('mouse::enter', function()
    button.disconnect_signal('press', on_unfocus)
  end)

  instance:connect_signal('property::visible', function(self)
    if not self.visible then
      button.disconnect_signal('press', on_unfocus)
    end
  end)

  --

  table.insert(instances, instance)
  return instance
end

return menupanel