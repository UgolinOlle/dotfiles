local wezterm = require("wezterm")

local M = {
	font_size = 12.5,
	line_height = 1.4,
	font = wezterm.font_with_fallback({ { family = "JetbrainsMono Nerd Font" } }),
	window_decorations = "RESIZE",
	hide_tab_bar_if_only_one_tab = true,
	default_cursor_style = "BlinkingUnderline",
	-- colors = require("themes.cyberdream"),
	color_scheme = "Abernathy",
	window_padding = {
		left = 20,
		right = 20,
		top = 20,
		bottom = 20,
	},
	max_fps = 120,
	prefer_egl = true,
	window_background_opacity = 0.9,
	macos_window_background_blur = 20,
	pane_focus_follows_mouse = true,
}

return M

-- { family = "CommitMono" },
