client.connect_signal("manage", function(c)
  Rules.check_title(c)
  c.x_focus_date = Utils.seconds()
end)

client.connect_signal("property::name", function(c)
  Rules.check_title(c)
end)

client.connect_signal("property::fullscreen", function(c)
  Utils.check_fullscreen(c)
end)

client.connect_signal("focus", function(c)
  c.x_focus_date = Utils.seconds()
end)