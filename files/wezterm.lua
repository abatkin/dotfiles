local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.initial_rows = 60
config.initial_cols = 150

config.font = wezterm.font("FiraCode Nerd Font Mono")
config.font_size = 10
config.freetype_load_target = "Light"
-- config.hide_mouse_cursor_when_typing = false

config.keys = {
	{
		key = "LeftArrow",
		mods = "SHIFT",
		action = act.ActivateTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "SHIFT",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "LeftArrow",
		mods = "SHIFT|CTRL",
		action = act.MoveTabRelative(-1),
	},
	{
		key = "RightArrow",
		mods = "SHIFT|CTRL",
		action = act.MoveTabRelative(1),
	},
}

return config
