local color = require("gears.color")
local shad = {}

shad.shadow_color = color("#282c34")
shad.shadow_light = color("#56666f")
shad.line_width = 1
shad.line_width_2 = 2

function shad.button_normal(bg_color)
  return function(context, cr, width, height)
    cr:set_source(color(bg_color))
    cr:paint()
    cr:set_source(shad.shadow_light)
    cr:rectangle(0, 0, width, shad.line_width)
    cr:rectangle(0, 0, shad.line_width, height)
    cr:fill()
    cr:set_source(shad.shadow_color)
    cr:rectangle(width - shad.line_width, 0, shad.line_width, height)
    cr:rectangle(0, height - shad.line_width, width, shad.line_width)
    cr:fill()
  end
end

function shad.button_pressed(bg_color)
  return function(context, cr, width, height)
    cr:set_source(color(bg_color))
    cr:paint()
    cr:set_source(shad.shadow_light)
    cr:rectangle(0, 0, width, shad.line_width_2)
    cr:rectangle(0, 0, shad.line_width_2, height)
    cr:fill()
    cr:set_source(shad.shadow_color)
    cr:rectangle(width - shad.line_width_2, 0, shad.line_width_2, height)
    cr:rectangle(0, height - shad.line_width_2, width, shad.line_width_2)
    cr:fill()
  end
end

return shad