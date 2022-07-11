local gears = require("gears")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")

local autotimer = {}
autotimer.actions = {}

function autotimer.do_stop(name)
  if autotimer.actions[name] == nil then
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
    msg("Middle click to cancel")
  end

  args.on_middle_click = function()
    autotimer.cancel(name)
  end

  autotimer.actions[name].widget = multibutton.create(args).widget
  autotimer.widget:add(autotimer.actions[name].widget)
  autotimer.actions[name].date_started = os.time()
  msg(name.." in "..minutes.." minutes")
  autotimer.update()
end

function autotimer.cancel(name)
  if not autotimer.active(name) then
    msg(name.." is not active")
    return
  end
  
  autotimer.do_stop(name)
  msg(name.." cancelled")
end

function autotimer.update()
  for i, action in pairs(autotimer.actions) do
    if not autotimer.active(action.name) then
      return
    end
    
    d = os.time() - action.date_started
    r = action.timer.timeout - d
    m = math.ceil(r / 60)
    
    action.text_widget.text = action.name.." in "..m.." mins"
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
  timeout = 5,
  call_now = false,
  autostart = true,
  single_shot = false,
  callback = function() autotimer.update() end
}

return autotimer