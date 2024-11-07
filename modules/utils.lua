Utils = {}

local awful = require("awful")
local naughty = require("naughty")
local wibox = require("wibox")
local gears = require("gears")
local socket = require("socket")
local lockdelay = require("madwidgets/lockdelay/lockdelay")
local autotimer = require("madwidgets/autotimer/autotimer")
local context_client

local media_lock = lockdelay.create({
	action = function(cmd)
		Utils.spawn(cmd)
	end,
	delay = 250,
})

local tag_next_lock = lockdelay.create({
	action = function(sticky)
		Utils.switch_tag("next", sticky)
	end,
	delay = 100,
})

local tag_prev_lock = lockdelay.create({
	action = function(sticky)
		Utils.switch_tag("prev", sticky)
	end,
	delay = 100,
})

function Utils.msg(txt, info)
	local run = function() end

	if info and Utils.startswith(info, "https://") then
		run = function()
			Utils.open_tab(info)
		end
	end

	local n = naughty.notify({ title = " " .. tostring(txt) .. " " })

	n:connect_signal("destroyed", function(n, reason)
		if reason == naughty.notification_closed_reason.dismissed_by_user then
			run()
		end
	end)
end

function Utils.prev_client()
	awful.client.focus.history.previous()
	if client.focus then
		client.focus:raise()
	end
end

function Utils.center(c)
	awful.placement.centered(c, { honor_workarea = true })
end

function Utils.maximize(c)
	c.maximized = not c.maximized
	Utils.focus(c)
end

function Utils.maximize_on_cursor(c)
	local c = mouse.object_under_pointer()

	if c then
		Utils.maximize(c)
	end
end

function Utils.fullscreen(c)
	c.fullscreen = not c.fullscreen
	Utils.focus(c)
end

function Utils.on_top(c)
	c.ontop = not c.ontop
end

function Utils.check_fullscreen(c)
	Utils.my_screen().mywibar1.ontop = not c.fullscreen
	Utils.my_screen().mywibar2.ontop = not c.fullscreen
end

function Utils.focus(c)
	c:emit_signal("request::activate", "tasklist", { raise = true })
end

function Utils.close_current()
	local c = client.focus

	if c then
		c:kill()
	end
end

function Utils.close(c)
	c:kill()
end

function Utils.snap(c, axis, position)
	local f

	c.maximized = false

	if axis == "corner" then
		f = awful.placement.scale + position
	else
		f = awful.placement.scale + position + (axis and awful.placement["maximize_" .. axis] or nil)
	end

	f(c, {
		honor_workarea = true,
		to_percent = 0.5,
	})
end

function Utils.placement(c, what)
	awful.placement[what](c, { honor_workarea = true })
end

function Utils.launcher()
	Utils.spawn("rofi -modi drun -show drun -show-icons -no-click-to-exit")
end

function Utils.altab()
	Utils.spawn("rofi -show window -show-icons -no-click-to-exit")
end

function Utils.screenshot()
	Utils.spawn("flameshot gui")
end

function Utils.screenshot_window()
	Utils.spawn("spectacle -a")
end

function Utils.screenshot_screen()
	Utils.spawn("spectacle -m")
end

function Utils.randstring()
	Utils.run_script_2("randword.sh")
end

function Utils.randword()
	Utils.run_script_2("randword.sh word")
end

function Utils.to_clipboard(text)
	Utils.shellspawn('echo -n "' .. Utils.trim(Utils.escape_quotes(text)) .. '" | xclip -selection clipboard')
end

function Utils.escape_quotes(text)
	return string.gsub(text, '"', '\\"')
end

function Utils.trim(text)
	return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

function Utils.startswith(s1, s2)
	return string.sub(s1, 1, string.len(s2)) == s2
end

function Utils.show_menupanel(mode)
	Menupanels.main.start(mode)
end

function Utils.get_context_client()
	return context_client
end

function Utils.show_task_context(c)
	context_client = c
	Menupanels.context.start("mouse")
end

function Utils.show_client_title(c)
	Menupanels.utils.showinfo(c.name)
end

function Utils.stop_all_players()
	Utils.spawn("playerctl --all-players pause")
end

function Utils.lockscreen(suspend)
	local s = ""

	if suspend then
		s = "systemctl suspend; "
	end

	Utils.shellspawn(s .. "i3lock --color=000000 -n")
end

function Utils.suspend()
	Utils.lockscreen(true)
end

function Utils.unlockscreen()
	Utils.shellspawn("killall i3lock")
end

function Utils.alt_lockscreen()
	Utils.stop_all_players()
	Utils.lockscreen()
end

function Utils.open_tab(url)
	Utils.shellspawn("firefox-developer-edition --new-tab --url '" .. url .. "'")
end

function Utils.add_to_file(path, text, num)
	Utils.shellspawn(
		"echo '" .. text .. "' | cat - " .. path .. " | sponge " .. path .. " && sed -i '" .. num .. ",$ d' " .. path
	)
end

local log_path = os.getenv("HOME") .. "/.awm_log"

function Utils.add_to_log(text, announce)
	local txt = os.date("%c") .. " " .. Utils.trim(text)
	Utils.add_to_file(log_path, txt, 1000)

	if announce then
		Utils.msg("Added to log: " .. text)
	end
end

function Utils.show_log(name)
	Utils.shellspawn("geany " .. log_path)
end

local notifications_path = os.getenv("HOME") .. "/.awm_notifications"

function Utils.add_to_notifications(text)
	local clean = Utils.trim(text)

	if Utils.startswith(clean, "Volume:") then
		return
	end

	local txt = os.date("%c") .. " " .. clean
	Utils.add_to_file(notifications_path, txt, 1000)
end

function Utils.show_notifications(name)
	Utils.shellspawn("geany " .. notifications_path)
end

function Utils.calendar()
	Utils.spawn("osmo")
end

function Utils.increase_volume(osd)
	Globals.volumecontrol.increase(osd)
end

function Utils.decrease_volume(osd)
	Globals.volumecontrol.decrease(osd)
end

function Utils.set_volume(v)
	Globals.volumecontrol.set_round(v)
end

function Utils.max_volume()
	local v = Globals.volumecontrol.max_volume
	Globals.volumecontrol.set_round(v)
end

function Utils.min_volume()
	Globals.volumecontrol.set_round(30)
end

function Utils.refresh_volume()
	Globals.volumecontrol.refresh()
end

function Utils.spawn(cmd)
	awful.spawn(cmd, false)
end

function Utils.spawn_2(cmd)
	awful.spawn(cmd)
end

function Utils.shellspawn(cmd)
	awful.spawn.with_shell(cmd, false)
end

function Utils.singlespawn(cmd)
	awful.spawn.single_instance(cmd)
end

function Utils.run_script(cmd)
	Utils.spawn(Globals.conf_dir .. "/scripts/" .. cmd)
end

function Utils.run_script_2(cmd)
	Utils.spawn(os.getenv("HOME") .. "/scripts/" .. cmd)
end

function Utils.width_factor(n, c)
	local width = Utils.my_screen().workarea.width * n

	if c then
		local border = c.border_width or 0
		width = width - (border * 2)
	end

	return width
end

function Utils.height_factor(n, c)
	local height = Utils.my_screen().workarea.height * n

	if c then
		local border = c.border_width or 0
		height = height - (border * 2)
	end

	return height
end

function Utils.ratio(c)
	return c.width / c.height
end

function Utils.grow_in_place(c)
	Utils.focus(c)
	c.maximized = false
	c.height = c.height + 20
	c.width = c.width + (20 * Utils.ratio(c))
	Utils.center(c)
end

function Utils.shrink_in_place(c)
	Utils.focus(c)
	c.maximized = false
	c.height = c.height - 20
	c.width = c.width - (20 * Utils.ratio(c))
	Utils.center(c)
end

function Utils.my_screen()
	return awful.screen.focused()
end

function Utils.my_tag()
	return Utils.my_screen().selected_tag
end

function Utils.clients()
	local filtered = {}
	local clients = Utils.my_tag():clients()

	for i = 1, #clients do
		local c = clients[i]

		if not Dropdowns.included(c) then
			table.insert(filtered, c)
		end
	end

	return filtered
end

function Utils.open_terminal(cmd)
	Utils.spawn("alacritty -o font.size=12 -e " .. cmd)
end

function Utils.system_monitor()
	Utils.open_terminal("btop")
end

function Utils.system_monitor_temp()
	Utils.open_terminal("watch -n 2 sensors")
end

-- To run nethogs without sudo you need to do this once:
-- sudo setcap "cap_net_admin,cap_net_raw=ep" /usr/bin/nethogs
function Utils.network_monitor()
	Utils.open_terminal("nethogs")
end

function Utils.space()
	return wibox.widget.textbox(" ")
end

function Utils.show_clipboard()
	Utils.spawn("clipton")
end

function Utils.switch_tag(direction, sticky)
	Dropdowns.check()
	local index = Utils.my_tag().index
	local num_tags = #Utils.my_screen().tags
	local ok = (direction == "next" and index < num_tags) or (direction == "prev" and index > 1)
	local new_index

	if ok then
		if direction == "next" then
			new_index = index + 1
		elseif direction == "prev" then
			new_index = index - 1
		end

		s_index = new_index

		local new_tag = Utils.my_screen().tags[new_index]

		if sticky then
			if client.focus and client.focus.screen == Utils.my_screen() then
				client.focus:move_to_tag(new_tag)
			end
		end

		new_tag:view_only()
	end
end

function Utils.next_tag(sticky)
	tag_next_lock.trigger(sticky)
end

function Utils.prev_tag(sticky)
	tag_prev_lock.trigger(sticky)
end

function Utils.next_tag_all()
	i = Utils.my_tag().index + 1

	if i > #Utils.my_screen().tags then
		i = #Utils.my_screen().tags
	end

	for s in screen do
		Utils.goto_tag(s, i)
	end
end

function Utils.prev_tag_all()
	i = Utils.my_tag().index - 1

	if i < 1 then
		i = 1
	end

	for s in screen do
		Utils.goto_tag(s, i)
	end
end

function Utils.goto_tag(s, i)
	local tag = s.tags[i]

	if tag then
		tag:view_only()
	end
end

function Utils.sleep(n)
	os.execute("sleep " .. tonumber(n))
end

function Utils.show_audio_controls()
	Utils.shellspawn("python ~/code/empris/empris.py")
end

function Utils.move_to_tag(t)
	if client.focus then
		client.focus:move_to_tag(t)
		t:view_only()
	end
end

function Utils.to_screen_tag(c, screen_index, tag_index)
	if c then
		tag = screen[screen_index].tags[tag_index]
		c:move_to_tag(tag)
		tag:view_only()
	end
end

function Utils.auto_suspend(minutes)
	autotimer.start_timer("Suspend", minutes, function()
		Utils.suspend()
	end)
end

function Utils.timer(title, minutes)
	autotimer.start_timer(title, minutes, function()
		Utils.msg(title .. " ended")
	end)
end

function Utils.counter(title)
	autotimer.start_counter(title)
end

function Utils.isempty(s)
	return s == nil or s == ""
end

function Utils.highest_in_tag(tag)
	for _, c in ipairs(client.get(tag.screen, true)) do
		if Utils.table_contains(c:tags(), tag) then
			return c
		end
	end
end

function Utils.table_contains(tab, val)
	for index, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function Utils.fake_input_do(
	ctrl,
	shift,
	alt,
	key
)
	local timer = gears.timer({
		timeout = 0.11,
	})

	if ctrl == nil then
		ctrl = false
	end

	if shift == nil then
		shift = false
	end

	if alt == nil then
		alt = false
	end

	timer:connect_signal("timeout", function()
		root.fake_input("key_release", "Super_L")
		root.fake_input("key_release", "Super_R")
		root.fake_input("key_release", "Control_L")
		root.fake_input("key_release", "Control_R")
		root.fake_input("key_release", "Shift_L")
		root.fake_input("key_release", "Shift_R")
		root.fake_input("key_release", "Alt_L")
		root.fake_input("key_release", "Alt_R")
		root.fake_input("key_release", "Delete")
		root.fake_input("key_release", "Escape")
		root.fake_input("key_release", "Home")
		root.fake_input("key_release", "End")
		root.fake_input("key_release", "F5")
		root.fake_input("key_release", "w")

		if ctrl then
			root.fake_input("key_press", "Control_L")
		end

		if shift then
			root.fake_input("key_press", "Shift_L")
		end

		if alt then
			root.fake_input("key_press", "Alt_L")
		end

		root.fake_input("key_press", key)
		root.fake_input("key_release", key)
		timer:stop()
	end)

	timer:start()
end

function Utils.minimize(c)
	if client.focus == c then
		if Frames.cycle(c) then
			return
		end
	end

	c:activate({ context = "tasklist", action = "toggle_minimization" })
end

function Utils.smart_close_current()
	local c = client.focus

	if c then
		Utils.smart_close(c)
	end
end

function Utils.smart_close_cursor(c)
	local c = mouse.object_under_pointer()

	if c then
		Utils.smart_close(c)
	end
end

function Utils.smart_close(c)
	if not c then
		return
	end

	if not c.x_keys then
		return
	end

	if c.x_no_close then
		return
	end

	if Dropdowns.included(c) then
		Dropdowns.hide_all()
		return
	end

	if c.kill then
		if (c.instance == "Navigator") or (c.instance == "code") then
			Utils.focus(c)

			Utils.fake_input_do(true, false, false, "w")
		else
			c:kill()
		end
	end
end

function Utils.smart_button(c)
	local c = mouse.object_under_pointer()
	if not c then
		return
	end
	if not c.x_client then
		return
	end

	if c.x_terminal then
		Utils.focus(c)
		Utils.run_script("restart.rb " .. c.instance)
	elseif c.x_frame ~= "none" then
		Rules.reset(c)
	elseif not Dropdowns.included(c) then
		if #Utils.clients() > 1 then
			Utils.minimize(c)
		end
	end
end

function Utils.bluetooth(on)
	local cmd
	local mac = "1C:6E:4C:8B:90:53"

	if on then
		cmd = "bluetoothctl connect " .. mac
	else
		cmd = "bluetoothctl disconnect " .. mac
	end

	Utils.spawn(cmd)
end

function Utils.corner_click()
	Dropdowns.toggle("utils")
end

function Utils.corner_middle_click() end

function Utils.corner_wheel_up() end

function Utils.corner_wheel_down() end

function Utils.middle_click(c)
	if c.x_alt_q then
		Utils.fake_input_do(false, false, true, "q")
	elseif c.x_ctrl_d then
		Utils.fake_input_do(true, false, false, "d")
	else
		Utils.focus(c)
	end
end

function Utils.first_tag()
	Utils.my_screen().tags[1]:view_only()
end

function Utils.seconds()
	return os.time()
end

function Utils.nano()
	return socket.gettime()
end

function Utils.decorate(c)
	c.titlebars_enabled = not c.titlebars_enabled

	if c.titlebars_enabled then
		awful.titlebar.show(c)
	else
		awful.titlebar.hide(c)
	end
end

function Utils.launch_dev()
	Utils.spawn("code")
	Utils.spawn("tilix --session ~/sessions/meltdown.json")
end

function Utils.tagbar_click()
	Dropdowns.toggle("utils")
end

function Utils.tagbar_right_click()
	Utils.altab()
end

function Utils.tagbar_middle_click()
	Utils.smart_close_current()
end

function Utils.tagbar_wheel_up()
	Utils.switch_tag("prev")
end

function Utils.tagbar_wheel_down()
	Utils.switch_tag("next")
end

function Utils.main_menu_click()
	Utils.show_menupanel("mouse")
end

function Utils.main_menu_right_click()
	Dropdowns.toggle("utils")
end

function Utils.main_menu_middle_click()
	Utils.stop_all_players()
	Utils.lockscreen()
end

function Utils.main_menu_wheel_up()
	Utils.switch_tag("prev")
end

function Utils.main_menu_wheel_down()
	Utils.switch_tag("next")
end

function Utils.clean_clients(clients)
	local filtered = {}

	for i = 1, #clients do
		local c = clients[i]

		if not Dropdowns.included(c) then
			table.insert(filtered, c)
		end
	end

	return filtered
end

function Utils.two_clients()
	local tag = Utils.my_tag()
	local clients = Utils.sort_index(tag.screen)
	clients = Utils.clean_clients(clients)

	if #clients < 2 then
		return
	end

	table.sort(clients, function(a, b)
		return a.first_tag.index > b.first_tag.index
	end)

	c1 = clients[1]
	c2 = clients[2]

	c1.maximized = false
	c2.maximized = false

	c1.border_width = 2
	c2.border_width = 2

	return c1, c2
end

function Utils.max_layout()
	for _, c in ipairs(Utils.clients()) do
		c.maximized = false
		c.border_width = 0
		c.width = Utils.width_factor(1, c)
		c.height = Utils.height_factor(1, c)
		Utils.placement(c, "top_left")
	end
end

function Utils.paper_horizontal_layout()
	local c1, c2 = Utils.two_clients()

	c1.width = Utils.width_factor(0.7, c1)
	c1.height = Utils.height_factor(1, c1)

	c2.width = Utils.width_factor(0.7, c2)
	c2.height = Utils.height_factor(1, c2)

	Utils.placement(c1, "left")
	Utils.placement(c2, "right")
end

function Utils.paper_vertical_layout()
	local c1, c2 = Utils.two_clients()

	c1.width = Utils.width_factor(1, c1)
	c1.height = Utils.height_factor(0.7, c1)

	c2.width = Utils.width_factor(1, c2)
	c2.height = Utils.height_factor(0.7, c2)

	Utils.placement(c1, "top")
	Utils.placement(c2, "bottom")
end

function Utils.horizontal_layout()
	local c1, c2 = Utils.two_clients()

	c1.width = Utils.width_factor(0.5, c1)
	c1.height = Utils.height_factor(1, c1)

	c2.width = Utils.width_factor(0.5, c2)
	c2.height = Utils.height_factor(1, c2)

	Utils.placement(c1, "left")
	Utils.placement(c2, "right")
end

function Utils.vertical_layout()
	local c1, c2 = Utils.two_clients()

	c1.width = Utils.width_factor(1, c1)
	c1.height = Utils.height_factor(0.5, c1)

	c2.width = Utils.width_factor(1, c2)
	c2.height = Utils.height_factor(0.5, c2)

	Utils.placement(c1, "top")
	Utils.placement(c2, "bottom")
end

function Utils.sort_index(s)
	local result = {}
	local unindexed = {}

	for _, c in pairs(client.get()) do
		if c.screen == s then
			if c.first_tag.index == s.selected_tag.index then
				if c.x_index > 0 then
					table.insert(result, c)
				else
					table.insert(unindexed, c)
				end
			end
		end
	end

	table.sort(result, function(a, b)
		return a.x_index < b.x_index
	end)

	for _, c in pairs(unindexed) do
		table.insert(result, c)
	end

	return result
end

function Utils.center_cursor()
    local screen = Utils.my_screen()
    local workarea = screen.workarea

    mouse.coords({
        x = workarea.x + workarea.width / 2,
        y = workarea.y + workarea.height / 2,
    })
end

function Utils.cursor_on_prev_screen()
	awful.screen.focus_relative(-1)
	Utils.center_cursor()
end

function Utils.cursor_on_next_screen()
	awful.screen.focus_relative(1)
	Utils.center_cursor()
end

function Utils.refresh_on_cursor()
	local c = mouse.object_under_pointer()

	if c then
		Utils.focus(c)
		Utils.fake_input_do(false, false, false, "F5")
	end
end

function Utils.home_on_cursor()
	local c = mouse.object_under_pointer()

	if c then
		Utils.focus(c)
		Utils.fake_input_do(true, false, false, "Home")
	end
end

function Utils.end_on_cursor()
	local c = mouse.object_under_pointer()

	if c then
		Utils.focus(c)
		Utils.fake_input_do(true, false, false, "End")
	end
end