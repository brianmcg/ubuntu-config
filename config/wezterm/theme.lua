local wezterm = require 'wezterm'
local utils = require 'utils'

local color_scheme = 'UbuntuCustom'
-- local color_scheme = 'Ubuntu'
-- local color_scheme = 'AdventureTime'
-- local color_scheme = 'Paraiso (dark) (terminal.sexy)'
-- local color_scheme = 'Argonaut (Gogh)'
-- local color_scheme = 'LiquidCarbonTransparent'

-- Custom schemes live in colors/<name>.toml; fall back to a builtin scheme
-- if no matching file exists.
local custom_scheme_path = wezterm.config_dir .. '/colors/' .. color_scheme .. '.toml'
local ok, custom_scheme = pcall(wezterm.color.load_scheme, custom_scheme_path)
local scheme = ok and custom_scheme or wezterm.color.get_builtin_schemes()[color_scheme]

local bg = wezterm.color.parse(scheme.background)
local red = wezterm.color.parse(scheme.ansi[2])
local green = wezterm.color.parse(scheme.ansi[3])
local yellow = wezterm.color.parse(scheme.ansi[4])
local blue = wezterm.color.parse(scheme.ansi[5])
local white = wezterm.color.parse(scheme.ansi[8])
local black = wezterm.color.parse(scheme.ansi[1])
local bright_red = wezterm.color.parse(scheme.brights[2])
local bright_green = wezterm.color.parse(scheme.brights[3])
local bright_yellow = wezterm.color.parse(scheme.brights[4])

return {
  color_scheme = color_scheme,
  font = 'Ubuntu Mono',
  font_size = 16,
  bg = {
    image = 'gradient-hexagons.jpg',
    opacity = 0
  },
  icons = {
    minimize = utf8.char(0xf444),
    maximize = utf8.char(0xf444),
    close = utf8.char(0xf444),
  },
  dividers = {
    left_arrow = utf8.char(0xe0ba),
    left_most = utf8.char(0x2588),
    right_arrow = utf8.char(0xe0bc),
  },
  colors = {
    tab_bar_bg = utils.with_alpha(bg, 0),
    active_tab_bg = utils.blend(bg:lighten(0.05), white, 0.2),
    active_tab_fg = white,
    inactive_tab_bg = utils.blend(bg:lighten(0.05), white, 0.05),
    inactive_tab_hover_bg = utils.blend(bg:lighten(0.05), white, 0.1),
    inactive_tab_fg = white,
    window_hide_fg = yellow,
    window_hide_fg_hover = bright_yellow,
    window_max_fg = green,
    window_max_fg_hover = bright_green,
    window_close_fg = red,
    window_close_fg_hover = bright_red,
    window_bg = bg
  }
}
