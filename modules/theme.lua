local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local theme = beautiful.get()
theme.font = "monospace 11"
beautiful.init(theme)

local fg1 = "#b8babc"
local bg0 = "#222020"
local bg1 = "#2B303B"
local bg2 = "#252933"
local border1 = "#445666"
local border2 = "#61AFEF"
local urgent_bg = "#18911D"
local urgent_fg = "#ffffff"

beautiful.wibar_height = 25
awful.mouse.snap.default_distance = 25
beautiful.bg_normal = bg0
beautiful.tasklist_fg_normal = fg1
beautiful.tasklist_bg_normal = bg2
beautiful.tasklist_bg_focus = bg1
beautiful.tasklist_fg_minimize = fg1
beautiful.tasklist_bg_minimize = bg2
beautiful.tasklist_shape_border_width = 1
beautiful.tasklist_shape_border_color = border1
beautiful.tasklist_shape_border_color_focus = border2
beautiful.notification_font = "monospace 18px"
beautiful.notification_icon_size = 100
beautiful.taglist_fg_focus = fg1
beautiful.taglist_bg_focus = bg1
beautiful.bg_systray = bg0
beautiful.bg_urgent = urgent_bg
beautiful.fg_urgent = urgent_fg