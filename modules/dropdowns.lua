-- Dropdowns are one or more clients that can be spawned on any tag
-- They get shown and dismissed on demand
-- They don't take space in the tasklist

Dropdowns = {}
Dropdowns.dd_utils_on = false
Dropdowns.dd_gpt_on = false
Dropdowns.dropdowns = { "utils", "gpt", "melt" }
Dropdowns.buttons = {}

function Dropdowns.setup()
	-- When changing tag, hide the active dropdown, on the specific screen
	tag.connect_signal("property::selected", function(t)
		Dropdowns.hide_screen(t.screen)
	end)
end

function Dropdowns.start_utils()
	Utils.spawn("dolphin")
	Utils.spawn("speedcrunch")
	Utils.spawn("tilix --session ~/sessions/main.json")
	Dropdowns.underline_text("utils")
end

function Dropdowns.start_gpt()
	Utils.spawn("firefox-developer-edition -P chatgpt2")
	Dropdowns.underline_text("gpt")
end

function Dropdowns.start_melt()
	Utils.spawn("meltdown --profile dropdown")
	Dropdowns.underline_text("melt")
end

Dropdowns.underline_text = function(what)
	active_screen = Dropdowns.get_screen(what)

	for _, item in ipairs(Dropdowns.buttons[what]) do
		if item.screen == active_screen then
			item.button.underline()
		else
			item.button.normal()
		end
	end
end

Dropdowns.normal_text = function(what)
	for _, item in ipairs(Dropdowns.buttons[what]) do
		item.button.normal()
	end
end

-- When raising a client from the tasklist
function Dropdowns.check_hide(c)
	if not Dropdowns.included(c) then
		Dropdowns.hide_screen(c.screen)
	end
end

function Dropdowns.included(c)
	for index, dropdown in ipairs(Dropdowns.dropdowns) do
		if c[Dropdowns.get_x(dropdown)] then
			return true
		end
	end

	return false
end

function Dropdowns.get_x(what)
	return "x_dropdown_" .. what
end

function Dropdowns.get_on(what)
	return Dropdowns["dd_" .. what .. "_on"]
end

function Dropdowns.set_on(what, value)
	Dropdowns["dd_" .. what .. "_on"] = value
end

function Dropdowns.get_tag(what)
	return Dropdowns["dd_" .. what .. "_tag"]
end

function Dropdowns.set_tag(what, value)
	Dropdowns["dd_" .. what .. "_tag"] = value
end

function Dropdowns.get_screen(what)
	return Dropdowns["dd_" .. what .. "_screen"]
end

function Dropdowns.set_screen(what, value)
	Dropdowns["dd_" .. what .. "_screen"] = value
end

function Dropdowns.toggle(what)
	if Dropdowns.get_on(what) then
		local tag = Dropdowns.get_tag(what)
		local highest = Utils.highest_in_tag(tag)
		local same_tag = tag == Utils.my_tag()

		if not same_tag or not tag.selected or (highest ~= nil and not highest[Dropdowns.get_x(what)]) then
			Dropdowns.show(what)
		else
			Dropdowns.hide(what)
		end
	else
		Dropdowns.show(what)
	end
end

function Dropdowns.show(what)
	Dropdowns.hide_screen(Utils.my_screen())
	local t = Utils.my_tag()
	local max

	for _, c in ipairs(client.get()) do
		if c[Dropdowns.get_x(what)] then
			c:move_to_tag(t)
			c.hidden = false
			c:raise()

			if not Dropdowns.get_on(what) then
				Rules.reset(c)
			else
				if c.maximized then
					max = c
				end
			end
		end
	end

	if max ~= nil then
		Utils.focus(max)
	end
	Dropdowns.set_on(what, true)
	Dropdowns.set_screen(what, Utils.my_screen())
	Dropdowns.set_tag(what, Utils.my_tag())
	Dropdowns.underline_text(what)
end

function Dropdowns.hide(what)
	for _, c in ipairs(client.get()) do
		if c[Dropdowns.get_x(what)] then
			c.hidden = true
		end
	end

	Dropdowns.set_on(what, false)
	Dropdowns.normal_text(what)
end

function Dropdowns.hide_others(what)
	for index, dropdown in ipairs(Dropdowns.dropdowns) do
		if dropdown ~= what then
			if Dropdowns.get_on(dropdown) then
				Dropdowns.hide(dropdown)
			end
		end
	end
end

function Dropdowns.hide_all()
	for index, dropdown in ipairs(Dropdowns.dropdowns) do
		Dropdowns.hide(dropdown)
	end
end

function Dropdowns.hide_screen(screen)
	local hid_some = false

	for index, dropdown in ipairs(Dropdowns.dropdowns) do
		if Dropdowns.get_on(dropdown) then
			if Dropdowns.get_screen(dropdown) == screen then
				Dropdowns.hide(dropdown)
				hid_some = true
			end
		end
	end

	return hid_some
end

function Dropdowns.check()
	for index, dropdown in ipairs(Dropdowns.dropdowns) do
		if Dropdowns.get_on(dropdown) then
			if Dropdowns.get_screen(dropdown) == Utils.my_screen() then
				Dropdowns.hide(dropdown)
			end
		end
	end
end

function Dropdowns.register_button(what, button, screen)
	if Dropdowns.buttons[what] == nil then
		Dropdowns.buttons[what] = {}
	end

	item = {}
	item.button = button
	item.screen = screen

	table.insert(Dropdowns.buttons[what], item)
end

Dropdowns.setup()
