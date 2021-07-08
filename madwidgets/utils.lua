local instance = {}

function instance.check_mouse_events(args)
  args.on_click = args.on_click or function() end
  args.on_middle_click = args.on_middle_click or function() end
  args.on_right_click = args.on_right_click or function() end
  args.on_wheel_up = args.on_wheel_up or function() end
  args.on_wheel_down = args.on_wheel_down or function() end
  args.on_mouse_enter = args.on_mouse_enter or function() end
  args.on_mouse_leave = args.on_mouse_leave or function() end
end

return instance