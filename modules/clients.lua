client.connect_signal("manage", function(c)
  check_title_rules(c)
end)

client.connect_signal("property::name", function(c)
  check_title_rules(c)
end)

client.connect_signal("property::fullscreen", function(c)
  check_fullscreen(c)
end)

client.connect_signal("focus", function(c)
  check_fullscreen(c)
end)