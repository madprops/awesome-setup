local awful = require("awful")
local beautiful = require("beautiful")
local naughty = require("naughty")

local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), "default")
beautiful.init(theme_path)

local theme = beautiful.get()
theme.font = "monospace 11"
beautiful.init(theme)

local color_white = "#ffffff"
local font_color = "#a8a8a8"
local bg_color = "#222222"
local highlight_color = "#3f3f3f"

beautiful.wibar_height = 25
beautiful.tasklist_fg_normal = font_color
beautiful.tasklist_bg_normal = bg_color
beautiful.tasklist_fg_focus = color_white
beautiful.tasklist_bg_focus = highlight_color
beautiful.tasklist_fg_minimize = font_color
beautiful.tasklist_bg_minimize = bg_color
beautiful.tasklist_shape_border_width = 1
beautiful.tasklist_shape_border_color = "#282c34"
beautiful.notification_font = "monospace 18px"
beautiful.notification_icon_size = 100
awful.mouse.snap.default_distance = 25