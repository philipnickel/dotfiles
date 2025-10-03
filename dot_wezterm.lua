local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- Prefer Nord everywhere
config.color_scheme = 'nord'

-- Font
config.font = wezterm.font('JetBrains Mono', { weight = 'Medium' })
config.font_size = 14.0

-- Let Option produce native characters (needed for DK layout brackets inside tmux)
config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

-- Window appearance
config.window_decorations = "RESIZE"
config.window_background_opacity = 0.75
config.macos_window_background_blur = 35
config.initial_rows = 50
config.initial_cols = 200

-- Remove padding around terminal content
config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

-- Tab bar configuration
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = false
config.show_new_tab_button_in_tab_bar = false
config.hide_tab_bar_if_only_one_tab = true

-- Nord-styled tab bar colors
config.colors = {
  tab_bar = {
    background = '#2E3440',
    active_tab = {
      bg_color = '#5E81AC',
      fg_color = '#ECEFF4',
    },
    inactive_tab = {
      bg_color = '#3B4252',
      fg_color = '#D8DEE9',
    },
    inactive_tab_hover = {
      bg_color = '#434C5E',
      fg_color = '#ECEFF4',
    },
    new_tab = {
      bg_color = '#2E3440',
      fg_color = '#D8DEE9',
    },
    new_tab_hover = {
      bg_color = '#434C5E',
      fg_color = '#ECEFF4',
    },
  },
}

-- Dim inactive panes slightly for visual hierarchy
config.inactive_pane_hsb = {
  saturation = 0.9,
  brightness = 0.85,
}

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_rate = 500

config.window_decorations = 'RESIZE'

-- Key bindings
config.keys = {
  -- Tab navigation
  { key = 't', mods = 'CMD', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'w', mods = 'CMD', action = wezterm.action.CloseCurrentTab { confirm = true } },
  { key = 'LeftArrow', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(-1) },
  { key = 'RightArrow', mods = 'CMD|SHIFT', action = wezterm.action.ActivateTabRelative(1) },
  -- Tab renaming
  { key = 'r', mods = 'CMD|SHIFT', action = wezterm.action.PromptInputLine {
    description = 'Enter new name for tab',
    action = wezterm.action_callback(function(window, pane, line)
      if line then
        window:active_tab():set_title(line)
      end
    end),
  }},
  -- Toggle maximize
  { key = 'Enter', mods = 'CMD|SHIFT', action = wezterm.action.ToggleFullScreen },
}

-- Event handling for mux attach/detach
wezterm.on('mux-server-connected', function(server_info)
  local gui = wezterm.gui
  if gui then
    local windows = gui.gui_windows()
    for _, window in ipairs(windows) do
      window:set_config_overrides({
        window_decorations = 'NONE',
      })
      window:maximize()
    end
  end
end)

wezterm.on('mux-server-disconnected', function()
  local gui = wezterm.gui
  if gui then
    local windows = gui.gui_windows()
    for _, window in ipairs(windows) do
      window:set_config_overrides({
        window_decorations = 'RESIZE',
      })
      window:restore()
    end
  end
end)

return config
