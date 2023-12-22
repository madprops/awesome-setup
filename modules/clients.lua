client.connect_signal("manage", function(c)
  Rules.check_title(c)
  Frames.apply_rules(c, 1)
  c.x_focus_date = Utils.nano()
  Frames.refresh(c.x_frame)
end)

client.connect_signal("unmanage", function(c)
  Frames.refresh(c.x_frame)
end)

client.connect_signal("property::name", function(c)
  Rules.check_title(c)
  Frames.apply_rules(c, 1)
end)

client.connect_signal("property::fullscreen", function(c)
  Utils.check_fullscreen(c)
end)

client.connect_signal("focus", function(c)
  c.x_focus_date = Utils.nano()
end)