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

  local u
  local s

  if minutes > 1 then
    u = utils.round(minutes)
    s = utils.pluralstring(u, "minute", "minutes")
  else
    u = utils.round(minutes * 60)
    s = utils.pluralstring(u, "second", "seconds")
  end

  utils.msg(name..": "..u.." "..s)
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
    
    local u
    local s

    if t > 1 then 
      u = utils.round(r / 60)
      s = utils.pluralstring(u, "min", "mins")
    else
      u = utils.round(r)
      s = utils.pluralstring(u, "sec", "secs")
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