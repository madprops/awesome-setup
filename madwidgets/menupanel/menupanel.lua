local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")

local instances = {}
local menupanel = {}
local modkey = "Mod4"

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function focus_button(instance, btn)
  btn.bg = beautiful.tasklist_bg_focus
  btn.fg = beautiful.tasklist_fg_focus
  if instance.args.speak then speak(btn.textbox.text) end
  instance.grabber_index = btn.xindex
  reset_confirm_charges(instance)
  unfocus_button(instance.hide_button)
end

function unfocus_button(btn)
  btn.fg = nil
  btn.bg = nil
end

function unfocus_except(instance, index)
  for i, btn in ipairs(instance.buttons) do
    if i == index then
      focus_button(instance, btn)
    else
      unfocus_button(btn)
    end
  end
end

function unfocus_all(instance)
  for i, btn in ipairs(instance.buttons) do
    unfocus_button(btn)
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
          reset_confirm_charges_except(instance, item.xindex)
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

function reset_confirm_charges_except(instance, index)
  for i, item in ipairs(instance.args.items) do
    if i ~= index then
      item.confirm_charge = 0
      local btn = instance.buttons[i]
      btn.textbox.text = btn.textbox.xoriginaltext
    end
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

  return button
end

function focus_hide_button(instance)
  instance.hide_button.bg = beautiful.tasklist_bg_focus
  instance.hide_button.fg = beautiful.tasklist_fg_focus
  unfocus_all(instance)
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
      {{modkey}, 'Return', function()
        if instance.grabber_index > 0 then
          action(instance, instance.args.items[instance.grabber_index], 2)
        else
          hide2(instance)
        end
      end},
      {{}, 'Escape', function() 
        hide2(instance)
      end},
      {{modkey}, 'Escape', function() 
        hide_all(instance)
      end},

      {{}, '1', function() 
        action(instance, instance.args.items[1], 1)
      end},
      {{}, '2', function() 
        action(instance, instance.args.items[2], 1)
      end},
      {{}, '3', function() 
        action(instance, instance.args.items[3], 1)
      end},
      {{}, '4', function() 
        action(instance, instance.args.items[4], 1)
      end},
      {{}, '5', function() 
        action(instance, instance.args.items[5], 1)
      end},
      {{}, '6', function() 
        action(instance, instance.args.items[6], 1)
      end},
      {{}, '7', function() 
        action(instance, instance.args.items[7], 1)
      end},
      {{}, '8', function() 
        action(instance, instance.args.items[8], 1)
      end},
      {{}, '9', function() 
        action(instance, instance.args.items[9], 1)
      end},

      {{modkey}, '1', function() 
        action(instance, instance.args.items[1], 2)
      end},
      {{modkey}, '2', function() 
        action(instance, instance.args.items[2], 2)
      end},
      {{modkey}, '3', function() 
        action(instance, instance.args.items[3], 2)
      end},
      {{modkey}, '4', function() 
        action(instance, instance.args.items[4], 2)
      end},
      {{modkey}, '5', function() 
        action(instance, instance.args.items[5], 2)
      end},
      {{modkey}, '6', function() 
        action(instance, instance.args.items[6], 2)
      end},
      {{modkey}, '7', function() 
        action(instance, instance.args.items[7], 2)
      end},
      {{modkey}, '8', function() 
        action(instance, instance.args.items[8], 2)
      end},
      {{modkey}, '9', function() 
        action(instance, instance.args.items[9], 2)
      end},
    }
  }

  -- Methods

  function instance.show()
    hide_all(instance)
    instance.screen = awful.screen.focused()
    instance.visible = true
    reset_confirm_charges(instance)

    local w = mouse.current_widget
    if w ~= nil and w.xindex ~= nil then
      instance.grabber_index = w.xindex
    else
      instance.grabber_index = 1
    end

    if instance.grabber_index == 0 then
      focus_hide_button(instance)
    else
      unfocus_except(instance, instance.grabber_index)
    end

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

    local textbox = create_textbox("("..i..") "..item.name)

    textbox:connect_signal("button::press", function(_, _, _, mode)
      action(instance, item, mode)
    end)

    textbox.xindex = i
    table.insert(instance.buttons, prepare_button(instance, textbox, i))
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
    local textbox = create_textbox(" x ")

    textbox:connect_signal("button::press", function(_, _, _, mode)
      hide2(instance)
    end)
    
    textbox.xindex = 0
    instance.hide_button = prepare_hide_button(instance, textbox)

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