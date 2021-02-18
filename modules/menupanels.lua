local beautiful = require("beautiful")
local menupanel = require("madwidgets/menupanel/menupanel")

local menupanels = {}
local autoclose_delay = 2

menupanels.main = menupanel.create({ 
  placement = "bottom",
  autoclose = true,
  autoclose_delay = autoclose_delay,
  hide_button = true,
  speak = false,
  on_middle_click = function()
    lockscreen()
  end,
  on_right_click = function()
    dropdown()
  end,
  on_wheel_up = function()
    prev_tag()
  end,
  on_wheel_down = function()
    next_tag()
  end,
  items = {
    {
      name = "Launch an Application",
      action = function() launcher() end,
      hide_on_click = true,
    },
    {
      name = "Apply Layout",
      action = function() layoutsmenu() end,
      hide_on_click = true,
    },
    {
      name = "Open Symbols Picker",
      action = function()
          symbolsmenu()
      end,
      hide_on_click = true,
    },
    {
      name = "Restart Awesome",
      action = function()
          needs_confirm(awesome.restart)
      end,
      hide_on_click = true,
    },
  }
})

menupanels.symbols = menupanel.create({ 
  placement = "bottom",
  autoclose = true,
  autoclose_delay = autoclose_delay,
  hide_button = true,
  items = {
    {
      name = "$",
      action = function() typestring("$") end,
      hide_on_click = false,
    },
    {
      name = "%",
      action = function() typestring("%") end,
      hide_on_click = false,
    },
    {
      name = "^",
      action = function() typestring("^") end,
      hide_on_click = false,
    },
    {
      name = "&",
      action = function() typestring("&") end,
      hide_on_click = false,
    },
    {
      name = "*",
      action = function() typestring("*") end,
      hide_on_click = false,
    },
  }
})

menupanels.confirm = menupanel.create({ 
  placement = "bottom",
  autoclose = true,
  autoclose_delay = autoclose_delay,
  hide_button = true,
  items = {
    {
      name = "Confirm",
      action = function() exec_confirm() end,
      hide_on_click = true,
    },
    {
      name = "Cancel",
      action = function() end,
      hide_on_click = true,
    }
  }
})

menupanels.layouts = menupanel.create({ 
  placement = "bottom",
  autoclose = true,
  autoclose_delay = autoclose_delay,
  hide_button = true,
  items = {
    {
      name = "Left / Right",
      action = function() apply_layout("left_right") end,
      hide_on_click = true,
    },
    {
      name = "Up / Down",
      action = function() apply_layout("up_down") end,
      hide_on_click = true,
    },
  }
})

return menupanels