local wezterm = require("wezterm")
local config = wezterm.config_builder()
local act = wezterm.action


SHELL = "/opt/homebrew/bin/fish"
config.color_scheme = "Catppuccin Frappe"

-- Font
config.font = wezterm.font("JetBrains Mono", { weight = "Medium" })
config.font_size = 14.0

-- Enable graphics protocols for inline images
config.enable_kitty_graphics = true

-- Let Option produce native characters (needed for DK layout brackets inside tmux)
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false
-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.70
config.macos_window_background_blur = 60
config.initial_rows = 50

-- Remove padding around terminal content
config.window_padding = { left = 0, right = 0, top = 0, bottom = 0 }

-- Tab bar configuration
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Make tab bar match window background
config.colors = {
	tab_bar = {
		background = "rgba(48, 52, 70, 0.75)",
	},
}

-- Cursor
config.default_cursor_style = "BlinkingBlock"
config.cursor_blink_rate = 500

-- --- KEYBINDINGS (define the table BEFORE inserting) ---
config.keys = {
	-- Tab navigation
	{ key = "t", mods = "CMD", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "w", mods = "CMD", action = act.CloseCurrentTab({ confirm = true }) },

	-- Tab renaming
	{
		key = "r",
		mods = "CMD|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
}

-- Disable dead keys (needed for DK layout brackets inside tmux)
config.use_dead_keys = false

return config
