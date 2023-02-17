local gears = require("gears")
local wibox = require("wibox")
local beautiful = require("beautiful")
local utils = require("madwidgets/utils")
local multibutton = require("madwidgets/multibutton/multibutton")

local autotimer = {}
autotimer.max_minutes = 60000
autotimer.actions = {}

function autotimer.count_active()
  local count = 0

  for i, action in pairs(autotimer.actions) do
    if action then
      count = count + 1
    end
  end

  return count
end

function autotimer.do_stop(name)
  if not autotimer.active(name) then
    return
  end

  if autotimer.actions[name].mode == "timer" then
    autotimer.actions[name].timer:stop()
  end

  autotimer.container:remove_widgets(autotimer.actions[name].widget)
  autotimer.actions[name] = nil

  if autotimer.count_active() == 0 then
    autotimer.widget.visible = false
  end
end

function autotimer.active(name)
  return autotimer.actions[name] ~= nil
end

function init_timer(name, minutes)
  local m = math.min(autotimer.max_minutes, minutes)

  autotimer.actions[name].timer = gears.timer.start_new(m * 60, function()
    local action = autotimer.actions[name].action
    autotimer.do_stop(name)
    action()
  end)
end

function autotimer.start_timer(name, minutes, action)
  if (minutes == 0) then return end

  autotimer.start(name)
  autotimer.actions[name].mode = "timer"
  
  local a = action or function () end
  autotimer.actions[name].action = a

  init_timer(name, minutes)
  autotimer.update()
end

function autotimer.start_counter(name)
  autotimer.start(name)
  autotimer.actions[name].mode = "counter"
  autotimer.update()
end

function autotimer.start(name)
  autotimer.do_stop(name)
  autotimer.actions[name] = {}
  autotimer.actions[name].name = name

  autotimer.actions[name].text_widget = wibox.widget {
    text = "",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  local args = {}
  args.widget = autotimer.actions[name].text_widget

  args.on_click = function ()
    if autotimer.actions[name].mode == "timer" then
      utils.msg("Middle click to stop. Wheel to increase or decrease")
    elseif autotimer.actions[name].mode == "counter" then
      utils.msg("Middle click to stop")
    end
  end

  args.on_wheel_down = function ()
    autotimer.add_minutes(name, -5)
  end
  
  args.on_wheel_up = function ()
    autotimer.add_minutes(name, 5)
  end

  args.on_middle_click = function()
    autotimer.stop(name)
  end

  args.fontcolor = autotimer.args.fontcolor
  args.bgcolor = autotimer.args.bgcolor

  autotimer.actions[name].widget = multibutton.create(args).widget
  autotimer.container:add(autotimer.actions[name].widget)
  autotimer.actions[name].date_started = os.time()
  autotimer.widget.visible = true
  utils.msg("Started "..name)
end

function autotimer.add_minutes(name, minutes)
  local action = autotimer.actions[name]

  if action.mode == "timer" then
    action.timer:stop()
    local d = os.time() - action.date_started
    local s = action.timer.timeout - d
    local sm = utils.round(s / 60)
    local m = utils.round_mult(s / 60, 5)
    local new_m

    if minutes > 0 then
      if m > sm then
        new_m = m
      else
        new_m = m + minutes
      end
    else
      if m < sm then
        new_m = m
      else
        new_m = m + minutes
      end
    end

    new_m = math.max(new_m, 1)
    action.date_started = os.time()
    init_timer(name, new_m)
    autotimer.update()
  end
end

function autotimer.stop(name)
  if not autotimer.active(name) then
    utils.msg(name.." is not active")
    return
  end
  
  autotimer.do_stop(name)
  utils.msg(name.." stopped")
end

function autotimer.update()
  for i, action in pairs(autotimer.actions) do
    if not autotimer.active(action.name) then
      return
    end
    
    local r
    local d = os.time() - action.date_started

    if action.mode == "timer" then
      if (action.timer == nil) then
        return
      end

      r = action.timer.timeout - d
    elseif action.mode == "counter" then
      if d / 60 >= autotimer.max_minutes then
        autotimer.do_stop(action.name)
        return
      end

      r = d
    end

    local t = r / 60
    local u
    local s

    if t >= 60 then
      u = utils.round_decimal(r / 60 / 60, 1)
      s = "hrs"
    elseif t >= 1 then 
      u = utils.numpad(utils.round(r / 60))
      s = "mins"
    else
      u = utils.numpad(utils.round(r))
      s = "secs"
    end

    action.text_widget.text = action.name..": "..u.." "..s
  end
end

function autotimer.create(args)
  args = args or {}
  args.separator = args.separator or "|"
  args.separator_color = args.separator_color or beautiful.fg_normal

  autotimer.container = wibox.widget {
    spacing = 25,
    spacing_widget = {
      markup = "<span fgcolor='"..args.separator_color.."'>"..gears.string.xml_escape(args.separator).."</span>",
      align  = "center",
      valign = "center",
      widget = wibox.widget.textbox,
  },
    widget = wibox.layout.fixed.horizontal
  }

  args.widget = autotimer.container
  autotimer.widget = multibutton.create(args).widget
  autotimer.widget.visible = false
  autotimer.args = args
end

autotimer.update_timer = gears.timer {
  timeout = 1,
  call_now = false,
  autostart = true,
  single_shot = false,
  callback = function() autotimer.update() end
}

return autotimer