-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.font_size = 12.2
config.bold_brightens_ansi_colors = true
config.freetype_load_target = "Light"
config.freetype_render_target = "HorizontalLcd"
config.freetype_load_flags = "NO_HINTING" -- seems to help rendering on high dpi screens
config.cell_width = 0.95
config.color_scheme = "tokyonight"
config.scrollback_lines = 10000
config.use_fancy_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
-- config.window_frame = {
-- 	font = wezterm.font({ family = "Hack Nerd Font", weight = "Regular" }),
-- }
config.keys = {
	{
		key = "k",
		mods = "CMD",
		action = wezterm.action.ClearScrollback("ScrollbackAndViewport"),
	},
	{
		key = "d",
		mods = "CMD",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "d",
		mods = "CMD|SHIFT",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "[", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
}

-- and finally, return the configuration to wezterm
return config
