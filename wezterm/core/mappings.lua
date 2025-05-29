local wz = require("wezterm")

local M = {
	leader = {
		key = "w",
		mods = "CTRL",
		timeout_milliseconds = 2000,
	},
	keys = {
		--- Miscellaneous
		{
			key = "q",
			mods = "LEADER",
			action = wz.action({ CloseCurrentPane = { confirm = true } }),
		},
		{
			key = "r",
			mods = "LEADER",
			action = wz.action.ReloadConfiguration,
		},
		{
			key = "n",
			mods = "LEADER",
			action = wz.action.ShowLauncher,
		},
		{
			key = "z",
			mods = "LEADER",
			action = wz.action.TogglePaneZoomState,
		},
		{
			key = "w",
			mods = "LEADER",
			action = wz.action.ShowTabNavigator,
		},

		--- Launcher
		{
			key = "x",
			mods = "CTRL|SHIFT",
			action = wz.action.SpawnCommandInNewTab({
				args = { "zsh", "-i", "-c", "zi" },
			}),
		},

		--- Split panes
		{
			key = "|",
			mods = "LEADER|SHIFT",
			action = wz.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "\\",
			mods = "LEADER",
			action = wz.action.SplitVertical({ domain = "CurrentPaneDomain" }),
		},

		--- Resize panes
		{
			key = "H",
			mods = "LEADER",
			action = wz.action.AdjustPaneSize({ "Left", 5 }),
		},
		{
			key = "J",
			mods = "LEADER",
			action = wz.action.AdjustPaneSize({ "Down", 5 }),
		},
		{ key = "K", mods = "LEADER", action = wz.action.AdjustPaneSize({ "Up", 5 }) },
		{
			key = "L",
			mods = "LEADER",
			action = wz.action.AdjustPaneSize({ "Right", 5 }),
		},

		--- Tab navigation
		{
			key = "Tab",
			mods = "CTRL",
			action = wz.action({ ActivateTabRelative = 1 }),
		},
		{
			key = "Tab",
			mods = "CTRL|SHIFT",
			action = wz.action({ ActivateTabRelative = -1 }),
		},

		--- Navigate between panes
		{
			key = "h",
			mods = "CTRL|OPT",
			action = wz.action.EmitEvent("switch-to-left"),
		},
		{
			key = "j",
			mods = "CTRL|OPT",
			action = wz.action.ActivatePaneDirection("Down"),
		},
		{
			key = "k",
			mods = "CTRL|OPT",
			action = wz.action.ActivatePaneDirection("Up"),
		},
		{
			key = "l",
			mods = "CTRL|OPT",
			action = wz.action.EmitEvent("switch-to-right"),
		},
	},
}

return M
