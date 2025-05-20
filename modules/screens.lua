local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local multibutton = require("madwidgets/multibutton/multibutton")
local sysmonitor = require("madwidgets/sysmonitor/sysmonitor")
local autotimer = require("madwidgets/autotimer/autotimer")

autotimer.create({
	left = "",
	fontcolor = Globals.niceblue,
	separator = "|",
	separator_color = Globals.nicedark,
})

local function sysmonitor_widget(mode)
	local args = {}
	args.mode = mode

	if mode == "cpu" or mode == "ram" or
		mode == "tmp" or mode == "gpu"
		or mode == "gpu_ram" then

		args.on_wheel_up = function()
			Utils.switch_tag("prev")
		end
		args.on_wheel_down = function()
			Utils.switch_tag("next")
		end
	else
		args.on_wheel_down = function()
			Utils.decrease_volume()
		end

		args.on_wheel_up = function()
			Utils.increase_volume()
		end
	end

	args.left_color = Globals.nicedark

	if mode == "cpu" then
		args.left = ""
		args.right = " | "
		args.right_color = Globals.nicedark
		args.on_click = function()
			Utils.system_monitor()
		end
	elseif mode == "ram" then
		args.right = " | "
		args.right_color = Globals.nicedark
		args.on_click = function()
			Utils.system_monitor()
		end
	elseif mode == "tmp" then
		args.right = " |"
		args.right_color = Globals.nicedark
		args.on_click = function()
			Utils.system_monitor_temp()
		end
	elseif mode == "gpu" then
		args.right = " | "
		args.on_click = function()
			Utils.system_monitor()
		end
	elseif mode == "gpu_ram" then
		args.on_click = function()
			Utils.system_monitor()
		end
	elseif mode == "net_download" then
		args.left = " " .. Globals.star .. " "
		args.left_color = Globals.niceblue
		args.right = " | "
		args.right_color = Globals.nicedark
		args.on_click = function()
			Utils.network_monitor()
		end
	elseif mode == "net_upload" then
		args.on_click = function()
			Utils.network_monitor()
		end
	end

	return sysmonitor.create(args)
end

local tags = {}
local num_tags = 20

for i = 1, num_tags do
	table.insert(tags, tostring(i))
end

local screen_num = 0
local max_screens = 1

awful.screen.connect_for_each_screen(function(s)
	screen_num = screen_num + 1

	if screen_num > max_screens then
		return
	end

	awful.tag(tags, s, awful.layout.suit.floating)

	-- Top Panel

	s.mytaglist = awful.widget.taglist({
		screen = s,
		filter = awful.widget.taglist.filter.all,
		buttons = {
			awful.button({}, 1, function(t)
				t:view_only()
			end),
			awful.button({}, 3, function(t)
				Utils.move_to_tag(t)
			end),
			awful.button({}, 4, function(t)
				Utils.switch_tag("prev")
			end),
			awful.button({}, 5, function(t)
				Utils.switch_tag("next")
			end),
		},
        widget_template = {
            {
                {
                    id = "text_role",
                    widget = wibox.widget.textbox,
                },
                id = "background_role",
                widget = wibox.container.background,
            },
            left = 5,
            right = 5,
            widget = wibox.container.margin
        },
	})

	s.mywibar1 = awful.wibar({
		ontop = true,
		position = "top",
		screen = s,
	})

	local left = {
		layout = wibox.layout.fixed.horizontal,
		multibutton.create({
			text = " " .. Globals.flower .. " ",
			on_click = function()
				Utils.main_menu_click()
			end,
			on_right_click = function()
				Utils.main_menu_right_click()
			end,
			on_middle_click = function()
				Utils.main_menu_middle_click()
			end,
			on_wheel_up = function()
				Utils.main_menu_wheel_up()
			end,
			on_wheel_down = function()
				Utils.main_menu_wheel_down()
			end,
		}),
		s.mytaglist,
	}

	local center = {
		layout = wibox.layout.align.horizontal,
		nil,
		multibutton.create({
			text = "",
			right_color = Globals.nicedark,
			on_wheel_up = function()
				Utils.switch_tag("prev")
			end,
			on_wheel_down = function()
				Utils.switch_tag("next")
			end,
		}),
		nil,
	}

	local systray = wibox.widget.systray()
	systray:set_screen(screen[Globals.primary_screen])
	local systray_container = wibox.layout.margin(systray, 0, 0, 3, 3)

	local audiocontrol = Globals.audiocontrol.create({
		right = " | ",
		right_color = Globals.nicedark,
	})

	-- Utils
	local utils_button = multibutton.create({
		text = "Utils",
		left = " " .. Globals.utils .. " ",
		right = " | ",
		right_color = Globals.nicedark,
		on_click = function()
			Dropdowns.toggle("utils")
		end,
		on_middle_click = function()
			Dropdowns.start_utils()
		end,
		on_wheel_up = function()
			Utils.switch_tag("prev")
		end,
		on_wheel_down = function()
			Utils.switch_tag("next")
		end,
	})

	Dropdowns.register_button("utils", utils_button, s)

	-- Melt
	local melt_button = multibutton.create({
		text = "Melt",
		left = Globals.melt .. " ",
		right = " | ",
		right_color = Globals.nicedark,
		on_click = function()
			Dropdowns.toggle("melt")
		end,
		on_middle_click = function()
			Dropdowns.start_melt()
		end,
		on_wheel_up = function()
			Utils.switch_tag("prev")
		end,
		on_wheel_down = function()
			Utils.switch_tag("next")
		end,
	})

	Dropdowns.register_button("melt", melt_button, s)

	local right = {
		layout = wibox.layout.fixed.horizontal(),
		autotimer.widget,
		Utils.space(),
		audiocontrol.widget,
		systray_container,
		utils_button,
		melt_button,
		sysmonitor_widget("cpu"),
		sysmonitor_widget("ram"),
		sysmonitor_widget("tmp"),
		-- sysmonitor_widget("gpu"),
		-- sysmonitor_widget("gpu_ram"),
		sysmonitor_widget("net_download"),
		sysmonitor_widget("net_upload"),
		Globals.volumecontrol.create({
			left = " " .. Globals.star .. " ",
			right = " " .. Globals.star .. " ",
			left_color = Globals.niceblue,
			right_color = Globals.niceblue,
			mutecolor = Globals.nicedark,
			maxcolor = Globals.nicegreen,
			on_click = function()
				Utils.show_audio_controls()
			end,
		}),
		-- multibutton.create({
		-- 	widget = wibox.widget.textclock("%a-%d-%b %I:%M:%S %P", 1),
		-- 	on_click = function()
		-- 		Utils.calendar()
		-- 	end,
		-- 	on_wheel_up = function()
		-- 		Utils.increase_volume()
		-- 	end,
		-- 	on_wheel_down = function()
		-- 		Utils.decrease_volume()
		-- 	end,
		-- 	right = " ",
		-- }),
	}

	s.mywibar1:setup({
		layout = wibox.layout.align.horizontal,
		left,
		center,
		right,
	})

	-- Bottom Panel

	s.mytasklist = awful.widget.tasklist({
		screen = s,
		buttons = Bindings.tasklist_buttons,
		filter = function()
			return true
		end,
		source = function()
			return Utils.sort_index(s)
		end,
		widget_template = {
			{
				{
					{
						{
							id = "icon_role",
							widget = wibox.widget.imagebox,
						},
						right = 10,
						top = 3,
						bottom = 3,
						widget = wibox.container.margin,
					},
					{
						id = "text_role",
						widget = wibox.widget.textbox,
					},
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			id = "background_role",
			widget = wibox.container.background,
		},
	})

	s.mywibar2 = awful.wibar({
		ontop = true,
		position = "bottom",
		screen = s,
	})

	s.mywibar2:setup({
		layout = wibox.layout.align.horizontal,
		nil,
		s.mytasklist,
		nil,
	})
end)

-- Double click titlebar
function double_click_event_handler(double_click_event)
	if double_click_timer then
		double_click_timer:stop()
		double_click_timer = nil
		return true
	end

	double_click_timer = gears.timer.start_new(0.20, function()
		double_click_timer = nil
		return false
	end)
end

client.connect_signal("request::titlebars", function(c)
	-- buttons for the titlebar
	local buttons = {
		awful.button({}, 1, function()
			-- WILL EXECUTE THIS ON DOUBLE CLICK
			if double_click_event_handler() then
				c.maximized = not c.maximized
				c:raise()
			else
				c:activate({ context = "titlebar", action = "mouse_move" })
			end
		end),
		awful.button({}, 3, function()
			c:activate({ context = "titlebar", action = "mouse_resize" })
		end),
	}

	awful.titlebar(c).widget = {
		{ -- Left
			awful.titlebar.widget.iconwidget(c),
			buttons = buttons,
			layout = wibox.layout.fixed.horizontal,
		},
		{ -- Middle
			{ -- Title
				halign = "center",
				widget = awful.titlebar.widget.titlewidget(c),
			},
			buttons = buttons,
			layout = wibox.layout.flex.horizontal,
		},
		{ -- Right
			awful.titlebar.widget.maximizedbutton(c),
			awful.titlebar.widget.ontopbutton(c),
			awful.titlebar.widget.closebutton(c),
			layout = wibox.layout.fixed.horizontal(),
		},
		layout = wibox.layout.align.horizontal,
	}
end)
