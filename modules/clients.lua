client.connect_signal("manage", function(c)
  Rules.check_title(c)
end)

client.connect_signal("property::name", function(c)
  Rules.check_title(c)
end)

client.connect_signal("property::fullscreen", function(c)
  Utils.check_fullscreen(c)
end)

client.connect_signal("property::minimized", function(c)
  if c.x_tiled then
    c.minimized = false
  end
end)