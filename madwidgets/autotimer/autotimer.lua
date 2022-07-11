local gears = require("gears")
local wibox = require("wibox")
local multibutton = require("madwidgets/multibutton/multibutton")

local autotimer = {}
local instances = {}
autotimer.timer = nil
autotimer.date_started = 0
autotimer.name = "Action"

function autotimer.do_stop()
  if autotimer.timer ~= nil then
    autotimer.timer:stop()
    autotimer.date_started = 0
  end

  autotimer.clear()
end

function autotimer.active()
  return autotimer.timer ~= nil and autotimer.date_started ~= 0
end

function autotimer.start(name, action, minutes)
  autotimer.do_stop()
  autotimer.name = name

  autotimer.timer = gears.timer.start_new(minutes * 60, function()
    autotimer.do_stop()
    action()
  end)

  autotimer.date_started = os.time()
  msg(name.." in "..minutes.." minutes")
  autotimer.update()
end

function autotimer.cancel()
  if not autotimer.active() then
    msg(autotimer.name.." is not active")
    return
  end
  
  autotimer.do_stop()
  msg(autotimer.name.." cancelled")
end

function autotimer.clear()
  for i, instance in ipairs(instances) do
    instance.text_widget.text = ""
  end
end

function autotimer.update()
  if not autotimer.active() then
    return
  end

  d = os.time() - autotimer.date_started
  r = autotimer.timer.timeout - d
  m = math.ceil(r / 60)

  for i, instance in ipairs(instances) do
    instance.text_widget.text = instance.args.space_left..autotimer.name.." in "..m.." mins"..instance.args.space_right
  end
end

function autotimer.create(args)
  args = args or {}
  args.space_left = args.space_left or " "
  args.space_right = args.space_right or " "
  
  local instance = {}
  instance.args = args

  instance.text_widget = wibox.widget {
    text = "",
    align  = "center",
    valign = "center",
    widget = wibox.widget.textbox
  }

  args.widget = instance.text_widget

  args.on_click = function ()
    msg("Middle click to cancel")
  end

  args.on_middle_click = function()
    autotimer.cancel()
  end
  
  instance.widget = multibutton.create(args).widget
  table.insert(instances, instance)
  return instance
end  

autotimer.update_timer = gears.timer {
  timeout = 5,
  call_now = false,
  autostart = true,
  single_shot = false,
  callback = function() autotimer.update() end
}

return autotimer