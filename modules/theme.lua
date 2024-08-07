local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.font = "monospace 13"
beautiful.wibar_height = 30
beautiful.tasklist_shape_border_width = 1
beautiful.notification_font = "monospace 18px"
beautiful.notification_icon_size = 30
beautiful.systray_icon_spacing = 5
awful.mouse.snap.default_distance = 25

-- Colors
local grey = "#b8babc"
local bg0 = "#222020"
local bg1 = "#2B303B"
local border = "#445666"
local green = "#18911D"
local white = "#ffffff"

beautiful.fg_normal = grey
beautiful.bg_normal = bg0
beautiful.bg_systray = bg0
beautiful.bg_urgent = green
beautiful.fg_urgent = white
beautiful.tasklist_shape_border_color = bg1
beautiful.tasklist_shape_border_color_focus = border
beautiful.tasklist_fg_normal = grey
beautiful.tasklist_bg_normal = bg0
beautiful.tasklist_fg_focus = white
beautiful.tasklist_bg_focus = bg1
beautiful.tasklist_fg_minimize = grey
beautiful.tasklist_bg_minimize = bg0
beautiful.tasklist_plain_task_name = true
beautiful.taglist_fg_focus = white
beautiful.taglist_bg_focus = bg1

-- Wallpaper
beautiful.wallpaper = Globals.conf_dir .. "wallpaper.jpg"
