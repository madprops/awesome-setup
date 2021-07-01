local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")

local instances = {}
local menupanel = {}
local modkey = "Shift"

function speak(txt)
  awful.util.spawn_with_shell('pkill espeak; espeak "'..txt..'"', false)
end

function focus_button(instance, btn)
  btn.bg = instance.args.bgcolor2
  btn.fg = instance.args.fontcolor
  btn.border_color = instance.args.bordercolor2
  if instance.args.speak then speak(btn.textbox.text) end
  instance.focused = btn.xindex
  reset_confirm_charges(instance)
  unfocus_button(instance, instance.hide_button)
end

function unfocus_button(instance, btn)
  btn.bg = instance.args.bgcolor
  btn.fg = instance.args.fontcolor
  btn.border_color = instance.args.bordercolor
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
  instance.focused = 0
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
    instance.args.parent.show(true)
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
          local btn = instance.buttons[item.xindex]
          confirm_charge_border(btn)
          if instance.args.speak then
            speak("Confirm "..btn.textbox.xoriginaltext)
          end
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

function basic_button(instance, textbox)
  return wibox.widget {
    textbox,
    widget = wibox.container.background,
    border_width = 1,
    border_color = instance.args.bordercolor
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
  local button = basic_button(instance, textbox)

  button.xindex = index
  button.textbox = textbox
  button.textbox.xoriginaltext = textbox.text

  button:connect_signal("mouse::enter", function(btn)
    unfocus_except(instance, index)
  end)

  return button
end

function prepare_hide_button(instance, textbox)
  local button = basic_button(instance, textbox)

  button:connect_signal("mouse::enter", function(btn)
    focus_hide_button(instance)
  end)

  return button
end

function focus_hide_button(instance)
  instance.hide_button.bg = instance.args.bgcolor2
  instance.hide_button.fg = instance.args.fontcolor
  instance.hide_button.border_color = instance.args.bordercolor2
  unfocus_all(instance)
end

function menupanel.create(args)
  if args.speak == nil then
    args.speak = false
  end

  if args.hide_button == nil then
    args.hide_button = true
  end

  args.height = args.height or 25
  args.hide_button_placement = args.hide_button_placement or "left"
  args.placement = args.placement or "bottom"
  args.bgcolor = args.bgcolor or "#21252b"
  args.bgcolor2 = args.bgcolor2 or "#2f333d"
  args.fontcolor = args.fontcolor or "#b8babc"
  args.bordercolor = args.bordercolor or "#485767"
  args.bordercolor2 = args.bordercolor2 or "#11a8cd"

  local instance = awful.popup({
    placement = args.placement,
    ontop = true,
    visible = true,
    border_width = 0,
    minimum_height = args.height,
    minimum_width = awful.screen.focused().geometry.width,
    widget = wibox.widget.background,
    bg = args.bgcolor,
    fg = args.fontcolor
  })

  instance.args = args
  instance.focused = 1

  instance.keygrabber = awful.keygrabber {
    keybindings = {
      {{}, 'Left', function()
        if instance.focused > 1 then
          instance.focused = instance.focused - 1
          unfocus_except(instance, instance.focused)
        else
          if args.hide_button_placement == "left" then
            focus_hide_button(instance)
          end
        end
      end},
      {{}, 'Right', function()
        if instance.focused < #instance.args.items then
          instance.focused = instance.focused + 1
          unfocus_except(instance, instance.focused)
        else
          if args.hide_button_placement == "right" then
            focus_hide_button(instance)
          end
        end
      end},
      {{}, 'Return', function()
        if instance.focused > 0 then
          action(instance, instance.args.items[instance.focused], 1)
        else
          hide2(instance)
        end
      end},
      {{modkey}, 'Return', function()
        if instance.focused > 0 then
          action(instance, instance.args.items[instance.focused], 2)
        else
          hide2(instance)
        end
      end},
      {{}, 'Escape', function() 
        hide2(instance)
      end},
      {{modkey}, 'Escape', function() 
        hide_all(instance)
      end}
    }
  }

  -- Methods

  function instance.show(samepos)
    hide_all(instance)
    instance.screen = awful.screen.focused()
    instance.visible = true
    reset_confirm_charges(instance)

    local w = mouse.current_widget
    if w ~= nil and w.xindex ~= nil then
      instance.focused = w.xindex
    elseif not samepos then
      instance.focused = 1
    end

    if instance.focused == 0 then
      focus_hide_button(instance)
    else
      unfocus_except(instance, instance.focused)
    end
    
    instance.keygrabber:start()
  end

  function instance.show_with_delay(delay)
    delay = delay or 0.02
    gears.timer.start_new(delay, function()
      instance.show()
    end)
  end

  function instance.hide()
    instance.visible = false
    instance.keygrabber:stop()
  end

  function instance.update_item(index, name, action)
    if name then
      instance.args.items[index].name = name
      instance.buttons[index].textbox.text = name
      instance.buttons[index].textbox.xoriginaltext = name
    end
    
    if action then
      instance.args.items[index].action = action
    end
  end

  function instance.get_item(index)
    return instance.args.items[index]
  end

  -- Items
  
  instance.buttons = {}

  for i, item in ipairs(args.items) do
    if item.needs_confirm == nil then
      item.needs_confirm = false
    end

    item.xindex = i
    item.confirm_charge = 0

    local textbox = create_textbox(item.name)

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

  -- Hide instances when clicking outside

  function on_unfocus()
    hide_all(instance)
  end

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

  -- Timer to give time for widget to get drawn

  gears.timer.start_new(2, function()
    instance.visible = false
  end)

  table.insert(instances, instance)
  return instance
end

return menupanel