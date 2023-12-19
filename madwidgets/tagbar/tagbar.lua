local awful = require("awful")
local wibox = require("wibox")
local utils = require("madwidgets/utils")
local topbar = require("madwidgets/topbar/topbar")

local tagbar = {}
local instances = {}

tagbar.colors = {
  "#2E3440",
  "#4169E1",
  "#008080",
  "#800080",
  "#4B0082",
}

function tagbar.setup()
  tag.connect_signal("property::selected", function(t)
    if not t.selected then
      return
    end

    for _, instance in ipairs(instances) do
      if instance.args.screen == t.screen then
        instance.update()
      end
    end
  end)
end

function tagbar.create(args)
  local instance = {}
  instance.args = args

  function instance.update()
    local index = utils.my_tag().index
    instance.widget.update("Desktop: " .. index)
    instance.widget.color(tagbar.colors[index])
  end

  instance.widget = topbar.create({
    screen = args.screen,
    bgcolor = args.topbar_color,
    on_click = args.on_click,
    on_right_click = args.on_right_click,
    on_middle_click = args.on_middle_click,
    on_wheel_down = args.on_wheel_down,
    on_wheel_up = args.on_wheel_up,
  })

  table.insert(instances, instance)
  instance.update()
  return instance
end

return tagbar