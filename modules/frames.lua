-- Frames are groups of clients that can be cycled through
-- They are placed in the same place on the screen
-- For instance you can have 3 clients in the top right
-- Only one tasklist item is shown at a time
-- Clicking the tasklist button cycles between them
-- You can also use the mousewheel

local awful = require("awful")

Frames = {}
Frames.frames = {}
local height_top = 0.64
local height_bottom = 0.36
local half_width = 0.5

Frames.frames.top_left = {
	screen = 2,
	width = half_width,
	height = height_top,
	x_index = 10,
	placement = "top_left",
}

Frames.frames.bottom_left = {
	screen = 2,
	width = half_width,
	height = height_bottom,
	x_index = 20,
	placement = "bottom_left",
}

Frames.frames.top_right = {
	screen = 2,
	width = half_width,
	height = height_top,
	x_index = 30,
	placement = "top_right",
}

Frames.frames.bottom_right = {
	screen = 2,
	width = half_width,
	height = height_bottom,
	x_index = 40,
	placement = "bottom_right",
}

function Frames.apply_rules(c, i)
	if c.x_frame_ready then
		return
	end

	local rules = Frames.frames[c.x_frame]

	if rules == nil then
		return
	end

	c.x_frame_ready = true
	c.maximized = false
	c.screen = rules.screen
	c.width = Utils.width_factor(rules.width)
	c.height = Utils.height_factor(rules.height)
	c.x_index = rules.x_index + i
	Utils.placement(c, rules.placement)
end

function Frames.start()
	for frame, _ in pairs(Frames.frames) do
		Frames.refresh(frame)
	end
end

function Frames.refresh(frame)
	if frame == "none" then
		return
	end

	local frames = {}

	for _, c in ipairs(client.get()) do
		if c.x_frame == frame then
			table.insert(frames, c)
		end
	end

	if #frames == 0 then
		return
	end

	for _, c in ipairs(frames) do
		c.skip_taskbar = true
	end

	table.sort(frames, function(a, b) return a.x_focus_date > b.x_focus_date end)
	frames[1].skip_taskbar = false
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