local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

local theme = beautiful.get()
theme.font = "monospace 11"
beautiful.init(theme)

local fg1 = "#b8babc"
local bg1 = "#33393B"
local bg2 = "#222222"
local border1 = "#282c34"

beautiful.wibar_height = 25
awful.mouse.snap.default_distance = 25
beautiful.tasklist_fg_normal = fg1
beautiful.tasklist_bg_normal = bg2
beautiful.tasklist_bg_focus = bg1
beautiful.tasklist_fg_minimize = fg1
beautiful.tasklist_bg_minimize = bg2
beautiful.tasklist_shape_border_width = 1
beautiful.tasklist_shape_border_color = border1
beautiful.notification_font = "monospace 18px"
beautiful.notification_icon_size = 100
beautiful.taglist_fg_focus = fg1
beautiful.taglist_bg_focus = bg1