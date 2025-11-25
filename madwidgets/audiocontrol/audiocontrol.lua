local awful = require("awful")
local wibox = require("wibox")
local beautiful = require("beautiful")
local multibutton = require("madwidgets/multibutton/multibutton")
local utils = require("madwidgets/utils")
local volumecontrol = require("madwidgets/volumecontrol/volumecontrol")

local audiocontrol = {}
local instances = {}
local player = "audacious"

function audiocontrol.create(args)
	args = args or {}
	local instance = {}
	instance.args = args
	args.fontcolor = args.fontcolor or beautiful.fg_normal

    args.on_wheel_up = function()
        volumecontrol.player_volume_up()
    end

    args.on_wheel_down = function()
        volumecontrol.player_volume_down()
    end

    local prev_args = utils.table_clone(args)

	prev_args.on_click = function()
		audiocontrol.prev()
	end

	prev_args.right = nil

    prev_args.widget = wibox.widget({
        markup = "◀",
        align = "center",
        valign = "center",
        font = font,
        widget = wibox.widget.textbox,
    })

	local prev_widget = multibutton.create(prev_args).widget

    local tooltip_prev = awful.tooltip({
        objects = { prev_widget },
        timer_function = audiocontrol.get_song_info,
        delay_show = 0.5
    })

	local play_args = utils.table_clone(args)

	play_args.on_click = function()
		audiocontrol.play_pause()
	end

	play_args.right = nil
	play_args.left = nil

    play_args.widget = wibox.widget({
        markup = "🎵",
        align = "center",
        valign = "center",
        font = font,
        widget = wibox.widget.textbox,
    })

	local play_pause_widget = multibutton.create(play_args).widget

    local tooltip_play = awful.tooltip({
        objects = { play_pause_widget },
        timer_function = audiocontrol.get_song_info,
        delay_show = 0.5
    })

	local next_args = utils.table_clone(args)

	next_args.on_click = function()
		audiocontrol.next()
	end

	next_args.left = nil

    next_args.widget = wibox.widget({
        markup = "▶",
        align = "center",
        valign = "center",
        font = font,
        widget = wibox.widget.textbox,
    })

	local next_widget = multibutton.create(next_args).widget

    local tooltip_next = awful.tooltip({
        objects = { next_widget },
        timer_function = audiocontrol.get_song_info,
        delay_show = 0.5
    })

	local separator_width = 5

	local layout = wibox.widget {
        prev_widget,
        wibox.widget {
            widget = wibox.widget.separator,
            forced_width = separator_width,
            opacity = 0
        },
        play_pause_widget,
        wibox.widget {
            widget = wibox.widget.separator,
            forced_width = separator_width,
            opacity = 0
        },
        next_widget,
        layout = wibox.layout.fixed.horizontal
    }

	instance.widget = layout
	table.insert(instances, instance)
	return instance
end

local player_cmd = "playerctl --player " .. player

audiocontrol.get_song_info = function()
    local title = io.popen(player_cmd .. " metadata title 2>/dev/null"):read("*all"):gsub("\n$", "")
    local artist = io.popen(player_cmd .. " metadata artist 2>/dev/null"):read("*all"):gsub("\n$", "")
    local album = io.popen(player_cmd .. " metadata album 2>/dev/null"):read("*all"):gsub("\n$", "")

    local info = ""
    if title ~= "" then info = info .. "Title: " .. title .. "\n" end
    if artist ~= "" then info = info .. "Artist: " .. artist .. "\n" end
    if album ~= "" then info = info .. "Album: " .. album end

    info = info or "Not playing"
	return info
end

audiocontrol.prev = function()
	local cmd = player_cmd .. " previous"
	os.execute(cmd)
end

audiocontrol.play_pause = function()
	local cmd = player_cmd .. " play-pause"
	os.execute(cmd)
end

audiocontrol.next = function()
	local cmd = player_cmd .. " next"
	os.execute(cmd)
end

return audiocontrol
