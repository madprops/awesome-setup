local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local beautiful = require("beautiful")
local utils = require("madwidgets/utils")
local multibutton = require("madwidgets/multibutton/multibutton")

local volumecontrol = {}
volumecontrol.max_volume = 100
volumecontrol.steps = 3

local instances = {}
local last_volume = 100

function volumecontrol.update_volume(vol)
	for i, instance in ipairs(instances) do
		if instance.shown_volume ~= vol then
			local s = volumecontrol.volstring(utils.numpad(vol, 3))
			instance.text_widget.text = s
			instance.shown_volume = vol

			if vol == 0 then
				instance.widget.fg = instance.args.mutecolor
			elseif vol == volumecontrol.max_volume then
				instance.widget.fg = instance.args.maxcolor
			else
				instance.widget.fg = instance.args.fontcolor
			end
		end
	end
end

function volumecontrol.get_volume(f)
	awful.spawn.easy_async_with_shell("pamixer --get-volume", function(o)
		if not utils.isnumber(o) then
			return
		end
		f(tonumber(o))
	end)
end

function volumecontrol.change_volume(vol)
	awful.spawn.with_shell("pamixer --set-volume " .. vol, false)
	volumecontrol.update_volume(vol)
end

function volumecontrol.set(vol)
	vol = tonumber(vol)

	if vol > volumecontrol.max_volume or vol < 0 then
		return
	end

	volumecontrol.change_volume(vol)
end

function volumecontrol.set_round(vol)
	vol = utils.round_mult(tonumber(vol), volumecontrol.steps)

	if vol > volumecontrol.max_volume or vol < 0 then
		return
	end

	volumecontrol.change_volume(vol)
end

function volumecontrol.osd(vol)
	utils.msg("Volume:" .. vol .. "%")
end

function volumecontrol.increase(osd)
	volumecontrol.get_volume(function(vol)
		if vol >= volumecontrol.max_volume then
			volumecontrol.update_volume(vol)
			return
		end

		vol = vol + volumecontrol.steps

		if vol > volumecontrol.max_volume then
			vol = volumecontrol.max_volume
		end

		vol = utils.round_mult(vol, volumecontrol.steps)
		volumecontrol.change_volume(vol)

		if osd ~= nil then
			volumecontrol.osd(vol)
		end
	end)
end

function volumecontrol.decrease(osd)
	volumecontrol.get_volume(function(vol)
		if vol == 0 then
			volumecontrol.update_volume(vol)
			return
		end

		vol = vol - volumecontrol.steps

		if vol < 0 then
			vol = 0
		end

		vol = utils.round_mult(tonumber(vol), volumecontrol.steps)
		volumecontrol.change_volume(vol)

		if osd ~= nil then
			volumecontrol.osd(vol)
		end
	end)
end

function volumecontrol.mute()
	volumecontrol.get_volume(function(vol)
		if vol == 0 then
			volumecontrol.set(last_volume)
		else
			last_volume = vol
			volumecontrol.set(0)
		end
	end)
end

function volumecontrol.refresh()
	volumecontrol.get_volume(function(vol)
		volumecontrol.update_volume(vol)
	end)
end

function volumecontrol.volstring(s)
	return "Vol:" .. s .. "%"
end

function volumecontrol.create(args)
	args = args or {}

	local instance = {}
	instance.args = args
	args.on_click = args.on_click or function() end
	args.fontcolor = args.fontcolor or beautiful.fg_normal
	args.mutecolor = args.mutecolor or beautiful.fg_normal
	args.maxcolor = args.maxcolor or beautiful.fg_normal

	instance.text_widget = wibox.widget({
		markup = volumecontrol.volstring("---"),
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	})

	args.widget = instance.text_widget

	args.on_middle_click = function()
		volumecontrol.mute()
	end

	args.on_wheel_down = function()
		volumecontrol.decrease()
	end

	args.on_wheel_up = function()
		volumecontrol.increase()
	end

	instance.widget = multibutton.create(args).widget
	instance.shown_volume = -1
	table.insert(instances, instance)

	if #instances == 1 then
		volumecontrol.timer = gears.timer({
			timeout = 3,
			call_now = false,
			autostart = true,
			single_shot = true,
			callback = function()
				volumecontrol.refresh()
			end,
		})
	end

	return instance
end

return volumecontrol
