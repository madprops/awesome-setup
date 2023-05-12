client.connect_signal("manage", function(c)
  Rules.check_title_rules(c)

  if c.xutil then
    c.hidden = true
  end
end)

client.connect_signal("property::name", function(c)
  Rules.check_title_rules(c)
end)

client.connect_signal("property::fullscreen", function(c)
  Utils.check_fullscreen(c)
end)