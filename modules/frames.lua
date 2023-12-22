Frames = {}

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
	local clients = Utils.clients()
	local focused

	for _, c2 in ipairs(clients) do
		if c2.x_frame == c1.x_frame then
			if c1.width == c2.width and c1.height == c2.height then
				if c1.x == c2.x and c1.y == c2.y then
					table.insert(frames, c2)
				end
			end
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

	for _, c2 in ipairs(frames) do
		c2.skip_taskbar = true

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