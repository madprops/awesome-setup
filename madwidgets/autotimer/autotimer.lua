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

  autotimer.actions[name].timer:stop()
  autotimer.widget:remove_widgets(autotimer.actions[name].widget)
  autotimer.actions[name] = nil
end

function autotimer.active(name)
  return autotimer.actions[name] ~= nil
end

function autotimer.start(name, action, minutes)
  autotimer.do_stop(name)

  autotimer.actions[name] = {}
  autotimer.actions[name].name = name
  
  autotimer.actions[name].timer = gears.timer.start_new(minutes * 60, function()
    autotimer.do_stop(name)
    action()
  end)

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
    utils.msg("Middle click to cancel")
  end

  args.on_middle_click = function()
    autotimer.cancel(name)
  end

  autotimer.actions[name].widget = multibutton.create(args).widget
  autotimer.widget:add(autotimer.actions[name].widget)
  autotimer.actions[name].date_started = os.time()

  if minutes > 1 then
    local m = math.ceil(minutes)
    local ms = utils.pluralstring(m, "minute", "minutes")
    utils.msg(name..": "..m.." "..ms)
  else
    local s = math.ceil(minutes * 60)
    local ss = utils.pluralstring(s, "second", "seconds")
    utils.msg(name..": "..s.." "..ss)
  end
  autotimer.update()
end

function autotimer.cancel(name)
  if not autotimer.active(name) then
    utils.msg(name.." is not active")
    return
  end
  
  autotimer.do_stop(name)
  utils.msg(name.." cancelled")
end

function autotimer.update()
  for i, action in pairs(autotimer.actions) do
    if not autotimer.active(action.name) then
      return
    end
    
    local d = os.time() - action.date_started
    local r = action.timer.timeout - d
    local t = r / 60

    if t > 1 then 
      local m = math.ceil(r / 60)
      local ms = utils.pluralstring(m, "min", "mins")
      action.text_widget.text = action.name..": "..m.." "..ms
    else
      local s = math.ceil(r)
      local ss = utils.pluralstring(s, "sec", "secs")
      action.text_widget.text = action.name..": "..s.." "..ss
    end
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