local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

-- Initialize default theme
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

-- State tracking to avoid spamming feh
local last_wallpaper_path = nil
local last_wallpaper_mode = nil

-- Helper function to read file content
local function read_file(path)
  local f = io.open(path, "r")

  if f then
    local content = f:read("*all")
    f:close()

    if content then
      return content:match("^%s*(.-)%s*$")
    end
  end

  return nil
end

-- Centralized update function
local function update_wallpaper()
  local config_dir = gears.filesystem.get_configuration_dir()
  local wp_path_file = config_dir .. "wallpaper.txt"
  local wp_mode_file = config_dir .. "wallpaper_mode.txt"

  -- 1. Determine Wallpaper Path
  local wallpaper = config_dir .. "wallpaper.jpg"
  local read_path = read_file(wp_path_file)

  if (read_path and (read_path ~= "")) then
    wallpaper = read_path
  end

  -- 2. Determine Wallpaper Mode
  local mode_str = "fill"
  local read_mode = read_file(wp_mode_file)

  if (read_mode and (read_mode ~= "")) then
    mode_str = read_mode
  end

  -- 3. Check for changes before spawning process
  if ((wallpaper ~= last_wallpaper_path) or (mode_str ~= last_wallpaper_mode)) then
    -- Map modes to feh flags
    local feh_flags = {
      fill   = "--bg-fill",
      max    = "--bg-max",
      scale  = "--bg-scale",
      tile   = "--bg-tile",
      center = "--bg-center"
    }

    local flag = feh_flags[mode_str]

    if not flag then
      flag = "--bg-fill"
    end

    -- Update theme variables
    beautiful.wallpaper = wallpaper
    beautiful.wallpaper_flag = flag
    last_wallpaper_path = wallpaper
    last_wallpaper_mode = mode_str

    -- Execute feh
    awful.spawn.with_shell("feh " .. flag .. " " .. wallpaper)
  end
end

-- Run immediately on startup
update_wallpaper()

-- Start the 10-second polling timer
gears.timer {
  timeout   = 10,
  call_now  = false,
  autostart = true,
  callback  = update_wallpaper
}