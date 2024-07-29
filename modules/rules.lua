local awful = require("awful")
local screen_left = 1
local screen_right = 2

Rules = {}

awful.rules.rules = {
	{
		rule = {},
		properties = {
			border_width = 0,
			focus = awful.client.focus.filter,
			raise = true,
			keys = Bindings.clientkeys,
			buttons = Bindings.clientbuttons,
			screen = awful.screen.preferred,
			placement = awful.placement.centered,
			skip_taskbar = false,
			titlebars_enabled = false,
			x_keys = true,
			x_rules_applied = false,
			x_client = true,
			x_terminal = false,
			x_dropdown_gpt = false,
			x_dropdown_utils = false,
			x_dropdown_melt = false,
			x_index = 0,
			x_focus_date = 0,
			x_frame = "none",
			x_frame_ready = false,
			x_alt_q = false,
			x_ctrl_d = false,
			border_color = "#00dbd7"
		},
		callback = function(c)
			if c.fullscreen then
				c.fullscreen = false
				c.fullscreen = true
			end
		end,
	},
	{
		rule = { class = "firefoxdeveloperedition" },
		properties = {
			x_hotcorner = "1_top_left",
			x_index = 1,
		},
	},
	{
		rule = { instance = "code" },
		properties = {
			screen = screen_left,
			maximized = true,
			x_terminal = true,
			x_index = 2,
		},
	},
	{
		rule = { instance = "fl64.exe" },
		properties = {
			maximized = true,
		},
	},
	{
		rule = { instance = "VirtualBox Machine" },
		properties = {
			maximized = false,
			x_keys = false,
		},
	},
	-- Screen Right
	{
		rule = { instance = "hexchat" },
		properties = {
			x_frame = "bottom_left",
		},
	},
	{
		rule = { instance = "audacious" },
		properties = {
			x_frame = "bottom_right",
			x_alt_q = true,
		},
	},
	{
		rule = { instance = "com.github.taiko2k.tauonmb" },
		properties = {
			x_frame = "bottom_right",
		},
	},
	{
		rule = { instance = "tauonmb" },
		properties = {
			x_frame = "bottom_right",
		},
	},
	{
		rule = { instance = "strawberry" },
		properties = {
			x_frame = "bottom_right",
			x_ctrl_d = true,
		},
	},
	{
		rule = { instance = "Devtools" },
		properties = {
			maximized = true,
			screen = screen_right,
			x_index = 1,
		},
	},
	{
		rule = { instance = "Nicotine" },
		properties = {
			x_frame = "top_left",
		},
	},
	{
		rule = { instance = "terminator" },
		properties = {
			maximized = true,
			x_terminal = true,
			x_no_close = true,
		},
	},
	{
		rule = { class = "cromulant" },
		properties = {
			x_frame = "top_right",
		},
	},
	{
		rule = { class = "cool-retro-term" },
		properties = {
			x_index = 1,
			width = Utils.width_factor(0.6),
			height = Utils.height_factor(1),
			placement = function(c)
				Utils.placement(c, "left")
			end,
			tag = "9",
			screen = screen_left,
		},
	},
	{
		rule = { class = "crom_stream" },
		properties = {
			x_index = 2,
			width = Utils.width_factor(0.4),
			height = Utils.height_factor(1),
			placement = function(c)
				Utils.placement(c, "right")
			end,
			tag = "9",
			screen = screen_left,
		},
	},
	{
		rule = { class = "crom_vid" },
		properties = {
			x_index = 2,
			height = Utils.height_factor(1),
			tag = "9",
			screen = screen_left,
		},
	},
	-- Util Screen
	{
		rule = { instance = "dolphin" },
		properties = {
			maximized = false,
			placement = function(c)
				Utils.placement(c, "top_left")
			end,
			width = Utils.width_factor(0.75),
			height = Utils.height_factor(0.5),
			skip_taskbar = true,
			x_dropdown_utils = true,
			x_terminal = true,
		},
	},
	{
		rule = { instance = "speedcrunch" },
		properties = {
			maximized = false,
			placement = function(c)
				Utils.placement(c, "top_right")
			end,
			width = Utils.width_factor(0.25),
			height = Utils.height_factor(0.5),
			skip_taskbar = true,
			x_dropdown_utils = true,
		},
	},
	{
		rule = { instance = "tilix" },
		properties = {
			maximized = false,
			placement = function(c)
				Utils.placement(c, "bottom")
			end,
			width = Utils.width_factor(1),
			height = Utils.height_factor(0.5),
			skip_taskbar = true,
			x_dropdown_utils = true,
			x_terminal = true,
		},
	},
	-- Other Rules
	{
		rule = { instance = "Alacritty" },
		properties = {
			maximized = false,
			placement = function(c)
				Utils.placement(c, "centered")
			end,
			width = Utils.width_factor(0.7),
			height = Utils.height_factor(0.7),
			x_terminal = true,
		},
	},
}

function Rules.check_title(c, force)
	if force == nil then
		force = false
	end

	-- c.maximized should be before awful.placement calls

	if Utils.startswith(c.name, "[ff_tile1]") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.x_frame = "top_left"
		end
	elseif Utils.startswith(c.name, "[ff_tile2]") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.x_frame = "top_right"
		end
	elseif Utils.startswith(c.name, "[ff_tile3]") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.x_frame = "bottom_right"
		end
	elseif Utils.startswith(c.name, "[chatgpt]") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.maximized = true
			c.width = Utils.width_factor(1)
			c.height = Utils.height_factor(1)
			c.skip_taskbar = true
			c.x_dropdown_gpt = true
		end
	elseif Utils.startswith(c.name, "[cytube]") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.width = Utils.width_factor(1)
			c.height = Utils.height_factor(0.64)
			c.screen = 2
		end
	elseif Utils.startswith(c.name, "Meltdown (dropdown)") then
		if not c.x_rules_applied or force then
			c.x_rules_applied = true
			c.width = Utils.width_factor(0.44)
			c.height = Utils.height_factor(0.8)
			c.skip_taskbar = true
			c.x_dropdown_melt = true
			c.border_width = 4
			c.border_color = "#ffa472"
		end
	elseif Utils.startswith(c.name, "Meltdown (dev)") then
		if not c.x_rules_applied or force then
			c.skip_taskbar = true
			c.x_dropdown_melt = true
			c.border_width = 4
			c.border_color = "#72dcff"
		end
	elseif Utils.startswith(c.name, "Meltdown (info)") then
		if not c.x_rules_applied or force then
			c.screen = screen_left
			c.x_index = 3
			c.height = Utils.height_factor(0.333)
			Utils.placement(c, "bottom_right")
		end
	end
end

function Rules.reset(c)
	awful.rules.apply(c)
	Rules.check_title(c, true)
	Frames.apply_rules(c, 1)
	c.x_focus_date = Utils.nano()
end

function Rules.apply(c)
	awful.rules.apply(c)
end
