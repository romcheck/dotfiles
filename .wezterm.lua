local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

config.initial_cols = 100
config.initial_rows = 30

config.window_decorations = "RESIZE"

config.keys = {
  {
    key = 'j',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Next',
  },
  {
    key = 'k',
    mods = 'CMD',
    action = wezterm.action.ActivatePaneDirection 'Prev',
  },
  {
    key = 'n',
    mods = 'CMD',
    action = wezterm.action.SplitVertical,
  },
  {
    key = 'n',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitHorizontal,
  },
  {
    key = 'm',
    mods = 'CMD|SHIFT',
    action = wezterm.action.SplitVertical {
      args = { '/bin/zsh', '-l', '-c', 'vifm' },
    },
  },
  {
     key = 't',
     mods = 'CMD',
     action = wezterm.action.SpawnCommandInNewTab {
       cwd = wezterm.home_dir,
     }
  },
  {
    key = 'm',
    mods = 'CMD',
    action = wezterm.action.SpawnCommandInNewTab {
      args = { '/bin/zsh', '-l', '-c', 'vifm' },
    },
  },
  {
    key = 'Return',
    mods = 'CMD',
    action = wezterm.action.TogglePaneZoomState,
  },
 }

config.use_fancy_tab_bar = false

config.color_scheme = 'OneDark (base16)'

config.font_size = 15
config.bold_brightens_ansi_colors = No
config.font = wezterm.font 'PragmataPro Mono Liga'
config.font_rules = {
  {
    intensity = 'Bold',
    font = wezterm.font {
      family = 'PragmataPro Mono Liga',
      weight = 'Regular',
    },
  },
  {
    italic = true,
    font = wezterm.font {
      family = 'PragmataPro Mono Liga',
      style = 'Normal'
    },
  },
}

config.check_for_updates = false

return config