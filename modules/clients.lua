client.connect_signal("manage", function(c)
  Rules.check_title_rules(c)
end)

client.connect_signal("property::name", function(c)
  Rules.check_title_rules(c)
end)

client.connect_signal("property::fullscreen", function(c)
  Utils.check_fullscreen(c)
end)

client.connect_signal("focus", function(c)
  if Utils.util_screen_on then
    if not c.xutil and Utils.util_screen_screen == Utils.myscreen() then
      Utils.hide_util_screen()
    end
  end
end)