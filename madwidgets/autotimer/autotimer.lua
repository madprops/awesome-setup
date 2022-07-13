local gears = require("gears")
local wibox = require("wibox")
local utils = require("madwidgets/utils")
local multibutton = require("madwidgets/multibutton/multibutton")

local autotimer = {}
autotimer.actions = {}

function autotimer.do_stop(name)
  if not autotimer.active(name) then
    return
  end

  if autotimer.actions[name].mode == "timer" then
    autotimer.actions[name].timer:stop()
  end

  autotimer.widget:remove_widgets(autotimer.actions[name].widget)
  autotimer.actions[name] = nil
end

function autotimer.active(name)
  return autotimer.actions[name] ~= nil
end

function autotimer.start_timer(name, action, minutes)
  autotimer.start(name)
  autotimer.actions[name].mode = "timer"
  
  autotimer.actions[name].timer = gears.timer.start_new(minutes * 60, function()
    autotimer.do_stop(name)
    action()
  end)

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
  args.left = autotimer.args.left
  args.right = autotimer.args.right

  args.on_click = function ()
    utils.msg("Middle click to stop")
  end

  args.on_middle_click = function()
    autotimer.cancel(name)
  end

  autotimer.actions[name].widget = multibutton.create(args).widget
  autotimer.widget:add(autotimer.actions[name].widget)
  autotimer.actions[name].date_started = os.time()
  utils.msg("Started "..name)
end

function autotimer.cancel(name)
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
  autotimer.args = args

  autotimer.widget = wibox.widget {
    spacing = 5,
    spacing_widget = {
        shape  = gears.shape.circle,
        widget = wibox.widget.separator,
    },
    widget = wibox.layout.fixed.horizontal
  }
end

autotimer.update_timer = gears.timer {
  timeout = 1,
  call_now = false,
  autostart = true,
  single_shot = false,
  callback = function() autotimer.update() end
}

return autotimer