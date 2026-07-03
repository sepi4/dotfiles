-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

-- or, changing the font size and color scheme.
config.font_size = 11
config.harfbuzz_features = { "calt = 0", "clig = 0", "liga = 0" } -- Remove annoying special characters in coding.

-- config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = true
config.warn_about_missing_glyphs = false

config.window_frame = {
	border_left_width = "0.1cell",
	border_right_width = "0.1cell",
	border_bottom_height = "0.05cell",
	border_top_height = "0.05cell",
	border_left_color = "gray",
	border_right_color = "gray",
	border_bottom_color = "gray",
	border_top_color = "gray",
}

-- config.window_decorations = "NONE"  -- remove the ugly title bar
config.enable_tab_bar = false -- if you don't need tabs
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.front_end = "WebGpu"   -- better rendering on some setups

config.enable_scroll_bar = true

-- config.window_padding = { -- remove pannings around
-- 	left = 2,
-- 	right = 2,
-- 	top = 0,
-- 	bottom = 0,
-- }

-- Finally, return the configuration to wezterm:
return config
