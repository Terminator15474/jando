local wezterm = require('wezterm') --[[@as Wezterm]]
local config = wezterm.config_builder()
config.automatically_reload_config = true

--config.color_scheme = "Tokyo Night Moon"

config.default_prog = { 'tmux', 'new-session', '-A' }

config.window_background_opacity = 0.6

config.hide_tab_bar_if_only_one_tab = true

config.enable_kitty_graphics = true

config.window_decorations = "RESIZE"

config.enable_wayland = false


wezterm.on('gui-startup', function(cmd)
	local tab, pane, window = wezterm.mux.spawn_window(cmd or {})
	window:gui_window():maximize()
end)

config.keys = {

	-- pass through keys
	{
		key = 'Space',
		mods = 'CTRL',
		action = wezterm.action.SendKey { key = 'Space', mods = 'CTRL' },
	},
	{
		key = 'Z',
		mods = 'CTRL',
		action = wezterm.action.SendKey { key = 'Z', mods = 'CTRL' }
	},

	{
		key = 'Backspace',
		mods = 'CTRL',
		action = wezterm.action.SendKey { key = 'Backspace', mods = 'CTRL' }
	},
}

-- OS specific configuration
if wezterm.target_triple:find("linux") then
	print("Running Linux config")
	require("linux").setup(config)
else
	print("Running Windows config")
	require("windows").setup(config)
end

require("multiplexing").setup(config)

return config
