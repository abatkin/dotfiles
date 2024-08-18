local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

config.initial_cols = 150
config.initial_rows = 50

config.font =
	wezterm.font_with_fallback({ "FiraCode Nerd Font", "JetBrains Mono", "Nerd Font Symbols", "Noto Color Emoji" })
config.font_size = 10
-- config.freetype_load_target = "Light"
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
	{
		key = "Insert",
		mods = "SHIFT",
		action = act.PasteFrom("Clipboard"),
	},
}

config.mouse_bindings = {
	{
		event = { Down = { streak = 1, button = "Middle" } },
		action = act.PasteFrom("Clipboard"),
	},
}

return config
