local wezterm = require "wezterm"

-- local mux = wezterm.mux
local act = wezterm.action

return {
  inactive_pane_hsb = { saturation = 0.7, brightness = 0.7 },
  color_scheme = "Ayu Mirage (Gogh)",
  font = wezterm.font("Hack"),
  font_size = 14.0,
  hide_tab_bar_if_only_one_tab = true,
  window_frame = {
    font = wezterm.font { family = 'Noto Sans', weight = 'Regular' },
  },
  background = {
    {
      source = {
        File = 'Users/joshhughes/.config/wezterm/runes.png',
      },
      vertical_align = "Top",
      horizontal_align = "Center",
      hsb = {
        brightness = 0.05
      },
    }
  },
  leader = { key = 'h', mods = 'CMD', timeout_milliseconds = 2000 },
  disable_default_key_bindings = true,
  key_tables = {
    resize_pane = {
      { key = 'LeftArrow',  action = act.AdjustPaneSize { 'Left', 1 } },
      { key = 'h',          action = act.AdjustPaneSize { 'Left', 1 } },

      { key = 'RightArrow', action = act.AdjustPaneSize { 'Right', 1 } },
      { key = 'l',          action = act.AdjustPaneSize { 'Right', 1 } },

      { key = 'UpArrow',    action = act.AdjustPaneSize { 'Up', 1 } },
      { key = 'k',          action = act.AdjustPaneSize { 'Up', 1 } },

      { key = 'DownArrow',  action = act.AdjustPaneSize { 'Down', 1 } },
      { key = 'j',          action = act.AdjustPaneSize { 'Down', 1 } },

      -- Cancel the mode by pressing escape
      { key = 'Escape',     action = 'PopKeyTable' },
    },
  },
  keys = {
    { key = 'h',          mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(-1) },
    { key = 'l',          mods = 'CTRL|SHIFT',  action = act.ActivateTabRelative(1) },
    { key = 'Enter',      mods = 'CMD',         action = act.ActivateCopyMode },
    { key = 'R',          mods = 'SHIFT|CTRL',  action = act.ReloadConfiguration },
    { key = '+',          mods = 'CTRL',        action = act.IncreaseFontSize },
    { key = '-',          mods = 'CTRL',        action = act.DecreaseFontSize },
    { key = '0',          mods = 'CTRL',        action = act.ResetFontSize },
    { key = 'C',          mods = 'SHIFT|CTRL',  action = act.CopyTo 'Clipboard' },
    { key = 'N',          mods = 'SHIFT|CTRL',  action = act.SpawnWindow },
    { key = 'U',          mods = 'SHIFT|CTRL',  action = act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' } },
    { key = 'v',          mods = 'CMD',         action = act.PasteFrom 'Clipboard' },
    { key = 'LeftArrow',  mods = 'SHIFT|CTRL',  action = act.ActivatePaneDirection 'Left' },
    { key = 'RightArrow', mods = 'SHIFT|CTRL',  action = act.ActivatePaneDirection 'Right' },
    { key = 'UpArrow',    mods = 'SHIFT|CTRL',  action = act.ActivatePaneDirection 'Up' },
    { key = 'DownArrow',  mods = 'SHIFT|CTRL',  action = act.ActivatePaneDirection 'Down' },
    { key = 'r',          mods = 'CTRL|SHIFT',  action = act.ActivateKeyTable { name = 'resize_pane', one_shot = false } },
    { key = 'f',          mods = 'CMD',         action = act.SplitVertical { domain = 'CurrentPaneDomain' }, },
    { key = 'd',          mods = 'CMD',         action = act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },
    { key = 'h',          mods = 'CMD',         action = act.ActivatePaneDirection 'Left' },
    { key = 'l',          mods = 'CMD',         action = act.ActivatePaneDirection 'Right' },
    { key = 't',          mods = 'CMD',         action = act.SpawnTab 'CurrentPaneDomain' },
    { key = 'w',          mods = 'CMD',         action = act.CloseCurrentTab { confirm = false } },
    { key = 'x',          mods = 'CMD',         action = act.CloseCurrentPane { confirm = false } },
    { key = 'b',          mods = 'LEADER|CTRL', action = act.SendString '\x02' },
    { key = 'Enter',      mods = 'LEADER',      action = act.ActivateCopyMode },
    { key = 'p',          mods = 'LEADER',      action = act.PasteFrom 'PrimarySelection' },
    { key = 'p',          mods = 'CTRL|SHIFT',  action = act.ActivateCommandPalette },
    {
      key = 'k',
      mods = 'CTRL|ALT',
      action = act.Multiple
          {
            act.ClearScrollback 'ScrollbackAndViewport',
            act.SendKey { key = 'L', mods = 'CTRL' }
          }
    },
  }
}
