local awful = require("awful")

Frames = {}
Frames.rules = {}
local height_top = 0.64
local height_bottom = 0.36
local half_width = 0.5

Frames.rules.top_left = {
	screen = 2,
	width = half_width,
	height = height_top,
	x_index = 10,
	placement = function(c)
		awful.placement.top_left(c, {honor_workarea = true})
	end,
}

Frames.rules.bottom_left = {
	screen = 2,
	width = half_width,
	height = height_bottom,
	x_index = 20,
	placement = function(c)
		awful.placement.bottom_left(c, {honor_workarea = true})
	end,
}

Frames.rules.top_right = {
	screen = 2,
	width = half_width,
	height = height_top,
	x_index = 30,
	placement = function(c)
		awful.placement.top_right(c, {honor_workarea = true})
	end,
}

Frames.rules.bottom_right = {
	screen = 2,
	width = half_width,
	height = height_bottom,
	x_index = 40,
	placement = function(c)
		awful.placement.bottom_right(c, {honor_workarea = true})
	end,
}

function Frames.apply_rules(c, i)
	local rules = Frames.rules[c.x_frame]

	if rules == nil then
		return
	end

	c.maximized = false
	c.screen = rules.screen
	c.width = Utils.width_factor(rules.width)
	c.height = Utils.height_factor(rules.height)
	c.x_index = rules.x_index + i
	rules.placement(c)
end

function Frames.cycle(c1, reverse, alt)
	if c1.x_frame == "none" then
		return false
	end

	if reverse == nil then
		reverse = false
	end

	if alt == nil then
		alt = false
	end

	local frames = {}
	local match = false
	local focused

	for _, c2 in ipairs(Utils.clients()) do
		if c2.x_frame == c1.x_frame then
			table.insert(frames, c2)
		end
	end

	if alt then
		table.sort(frames, function(a, b) return a.x_focus_date > b.x_focus_date end)
		focused = frames[1]
	else
		focused = c1
	end

	if #frames == 0 then
		return false
	end

	if reverse then
		table.sort(frames, function(a, b) return a.x_index > b.x_index end)
	else
		table.sort(frames, function(a, b) return a.x_index < b.x_index end)
	end

	local selected

	for i, c2 in ipairs(frames) do
		c2.skip_taskbar = true
		Frames.apply_rules(c2, i)

		if focused == c2 then
			match = true
		elseif match then
			selected = c2
		end
	end

	if frames[1] == focused then
		selected = frames[#frames]
	else
		selected = frames[1]
	end

	Utils.focus(selected)
	selected.skip_taskbar = false
	return true
end