-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}
local act = wezterm.action

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- This is where you actually apply your config choices
config.front_end = "WebGpu"
config.font_size = 13
config.font = wezterm.font({
	family = "JetBrains Mono",
	-- weight = "DemiBold",
})

-- config.bold_brightens_ansi_colors = true
-- config.freetype_load_target = "Light"
-- config.freetype_render_target = "HorizontalLcd"
-- config.freetype_load_flags = "NO_HINTING" -- seems to help rendering on high dpi screens
-- config.cell_width = 0.95
---
---Return the suitable argument depending on the appearance
---@param arg { light: any, dark: any } light and dark alternatives
---@return any
local function depending_on_appearance(arg)
	local appearance = wezterm.gui.get_appearance()
	if appearance:find("Dark") then
		return arg.dark
	else
		return arg.light
	end
end

config.color_scheme = "Catppuccin Mocha"
-- config.color_scheme = depending_on_appearance({
-- 	light = "Catppuccin Latte",
-- 	dark = "Catppuccin Mocha",
-- })
config.scrollback_lines = 10000
config.native_macos_fullscreen_mode = true

config.use_fancy_tab_bar = false
config.tab_max_width = 32
config.colors = {
	tab_bar = {
		active_tab = depending_on_appearance({
			light = { fg_color = "#f8f8f2", bg_color = "#209fb5" },
			dark = { fg_color = "#6c7086", bg_color = "#74c7ec" },
		}),
	},
}

config.enable_scroll_bar = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	-- Show tab navigator
	{
		key = "p",
		mods = "CMD",
		action = wezterm.action.ShowTabNavigator,
	},
	-- Show launcher menu
	{
		key = "P",
		mods = "CMD|SHIFT",
		action = wezterm.action.ShowLauncher,
	},
	{
		key = "k",
		mods = "CMD",
		action = act.Multiple({
			act.ClearScrollback("ScrollbackAndViewport"),
			act.SendKey({ key = "L", mods = "CTRL" }),
		}),
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
	-- Rename current tab
	{
		key = "E",
		mods = "CMD|SHIFT",
		action = wezterm.action.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, _, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "[", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Left") },
	{ key = "]", mods = "CMD", action = wezterm.action.ActivatePaneDirection("Right") },
}

config.mouse_bindings = {
	-- Change the default click behavior so that it only selects
	-- text and doesn't open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "NONE",
		action = act.CompleteSelection("ClipboardAndPrimarySelection"),
	},

	-- and make CMD-Click open hyperlinks
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CMD",
		action = act.OpenLinkAtMouseCursor,
	},
	-- NOTE that binding only the 'Up' event can give unexpected behaviors.
	-- Read more below on the gotcha of binding an 'Up' event only.
}

-- and finally, return the configuration to wezterm
return config
