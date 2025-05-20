local awful = require("awful")
local naughty = require("naughty")
local utils = {}

function utils.numpad(s, n)
	s = utils.round(tonumber(s))
	local ss = s

	if n == 3 then
		if s < 100 then
			ss = "0" .. s
		end
	end

	if s < 10 then
		ss = "0" .. ss
	end

	return ss
end

function utils.round(n)
	return math.floor(n + 0.5)
end

function utils.round_decimal(n, p)
	return tonumber(string.format("%." .. p .. "f", n))
end

function utils.round_mult(num, mult)
	return math.floor(num / mult + 0.5) * mult
end

function utils.indexof(value, array)
	for i, instance in ipairs(array) do
		if array[i] == value then
			return i
		end
	end
	return -1
end

function utils.isnumber(num)
	if not tonumber(num) then
		return false
	else
		return true
	end
end

function utils.msg(txt)
	naughty.notify({ title = " " .. tostring(txt) .. " " })
end

function utils.trim(text)
	return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

function utils.my_screen()
	return awful.screen.focused()
end

function utils.my_tag()
	return utils.my_screen().selected_tag
end

function utils.switch_tag(direction, sticky)
	local index = utils.my_tag().index
	local num_tags = #utils.my_screen().tags
	local ok = (direction == "next" and index < num_tags) or (direction == "prev" and index > 1)
	local new_index

	if ok then
		if direction == "next" then
			new_index = index + 1
		elseif direction == "prev" then
			new_index = index - 1
		end

		s_index = new_index

		local new_tag = utils.my_screen().tags[new_index]

		if sticky then
			if client.focus and client.focus.screen == utils.my_screen() then
				client.focus:move_to_tag(new_tag)
			end
		end

		new_tag:view_only()
	end
end

function utils.shift_pressed(mods)
	for _, mod in ipairs(mods) do
		if mod == "Shift" then
			return true
		end
	end

	return false
end

function utils.print_table(t, indent)
    indent = indent or ""

    for key, value in pairs(t) do
        if type(value) == "table" then
            utils.msg(indent .. key .. " : ")
            utils.print_table(value, indent .. "  ")
        else
            utils.msg(indent .. key .. " : " .. tostring(value))
        end
    end
end

function utils.remove_quotes(s)
	return string.gsub(s, "\"", "")
end

function utils.table_clone(t, deep)
    if type(t) ~= "table" then return t end

    local clone = {}
    for key, value in pairs(t) do
        if deep and type(value) == "table" then
            clone[key] = utils.table_clone(value, deep)
        else
            clone[key] = value
        end
    end
    return clone
end

return utils
