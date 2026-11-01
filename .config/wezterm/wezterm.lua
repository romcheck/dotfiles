local wezterm = require 'wezterm'

local config = wezterm.config_builder()

config.check_for_updates = false

config.send_composed_key_when_left_alt_is_pressed = true
config.quit_when_all_windows_are_closed = true
config.window_decorations = "RESIZE"

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}
config.initial_cols = 100
config.initial_rows = 30

config.use_fancy_tab_bar = false

config.color_scheme = 'OneDark (base16)'
-- config.color_scheme = 'flexoki-light'
-- config.color_scheme = 'Selenized Dark (Gogh)'
-- config.color_scheme = 'Selenized Light (Gogh)'
-- config.color_scheme = 'flexoki-light'
-- config.color_scheme = 'Everforest Light (Gogh)'
-- config.color_scheme = "Penumbra Light"
-- config.color_scheme = "Penumbra Alabaster Light"
-- config.color_scheme = "Alabaster Light"
-- config.color_scheme = "Alabaster L"
config.color_schemes = {
  ['Alabaster L'] = {
    foreground = "#000000",
    background = "#f7f7f7",
    cursor_bg = "#007acc",
    cursor_fg = "#bfdbfe",
    selection_bg = "#000000",
    selection_fg = "#f7f7f7",
    ansi = {
      "#000000",
      "#aa3731",
      "#448c27",
      "#cb9000",
      "#325cc0",
      "#7a3e9d",
      "#0083b2",
      "#b7b7b7"
    },
    brights = {
      "#777777",
      "#f05050",
      "#60cb00",
      "#f2af50",
      "#007acc",
      "#e64ce6",
      "#00aacb",
      "#f7f7f7"
    },
  }
}

config.harfbuzz_features = {
  -- "c2sc=1",
  -- "ccmp=1",
  -- "dnom=1",
  -- "frac=1",
  -- "hwid=1",
  -- "mark=1",
  -- "mkmk=1",
  -- "sinf=1",
  "liga=1",
  "clig=1",
  "calt=1",
  "dlig=1",
  "cv01=1",
  "cv02=1",
  "cv03=1",
  "cv04=1",
  "cv05=1",
  -- "ss03=1",
  -- "ss04=1",
  -- "ss05=1",
  -- "ss06=1",
  -- "ss07=1",
  -- "ss08=1",
  -- "ss09=1",
  -- "ss10=1",
  -- "ss11=1",
  -- "ss12=1",
  -- "ss13=1",
  -- "ss14=1",
  "ss15=1",
  -- "ss16=1",
  -- "ss17=1",
  "ss18=1",
  -- "ss19=1",
  -- "ss20=1",
}

config.bold_brightens_ansi_colors = false
config.font_size = 14

config.font = wezterm.font 'PragmataPro Liga'
-- config.freetype_load_target = "Light"
config.freetype_load_flags = "NO_HINTING"

config.font_rules = {
  {
    intensity = "Bold",
    font = wezterm.font {
      family = "PragmataPro Liga",
      weight = "Regular",
      style = "Normal",
    },
  },
  {
    italic = true,
    font = wezterm.font {
      family = "PragmataPro Liga",
      weight = "Regular",
      style = "Normal",
    },
  },
  {
    intensity = "Bold",
    italic = true,
    font = wezterm.font {
      family = "PragmataPro Liga",
      weight = "Regular",
      style = "Normal",
    },
  },
}

config.keys = {
  {
    key = 't',
    mods = 'CTRL',
    action = wezterm.action.RotatePanes 'Clockwise',
  },
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
    action = wezterm.action.SplitHorizontal {
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

local last_update_time = os.time()
local last_cwd = nil
local last_prompt = ""
local update_interval = 2

local shims = os.getenv("HOME") .. "/.local/share/mise/shims"
local path = shims .. ":/opt/homebrew/bin:/usr/bin:/bin:/usr/sbin:/sbin"

wezterm.on('update-status', function(window, pane)
  local now = os.time()
  local cwd_uri = pane:get_current_working_dir()
  local cwd = cwd_uri and cwd_uri.file_path or ""

  if cwd ~= last_cwd or (now - last_update_time) >= update_interval then
    local success, stdout = wezterm.run_child_process({
      "/usr/bin/env",
      "PATH=" .. path,
      "/opt/homebrew/bin/starship",
      "prompt",
      "--right",
      "--path=" .. cwd,
    })

    if success then
      last_prompt = stdout
      last_cwd = cwd
      last_update_time = now
    end
  end

  window:set_right_status(wezterm.format({
    { Text = " " .. last_prompt .. " " },
  }))
end)

return config
