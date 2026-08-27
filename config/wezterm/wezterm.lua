local wezterm = require 'wezterm'
local theme = require 'theme'
local utils = require 'utils'
local keys = require 'keys'

local config = wezterm.config_builder()

config.color_scheme = theme.color_scheme
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.keys = keys

config.background = {
  {
    source = {
      Color = theme.colors.window_bg
    },
    width = '100%',
    height = '100%',
  },
  {
    source = {
      File = wezterm.config_dir .. '/images/' .. theme.bg.image
    },
    horizontal_align = 'Center',
    vertical_align = 'Middle',
    width = 'Cover',
    height = 'Cover',
    opacity = theme.bg.opacity,
  },
}

config.font = wezterm.font_with_fallback { theme.font }
config.font_size = theme.font_size
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.tab_max_width = 24
config.show_new_tab_button_in_tab_bar = false

config.window_frame = {
  active_titlebar_bg = theme.colors.tab_bar_bg,
  inactive_titlebar_bg = theme.colors.tab_bar_bg,
  button_bg = theme.colors.tab_bar_bg,
  button_hover_bg = theme.colors.tab_bar_bg,
  button_fg = theme.colors.inactive_tab_bg,
  button_hover_fg = theme.colors.inactive_tab_hover_bg,
}

config.colors = {
  tab_bar = {
    background = theme.colors.tab_bar_bg,
    inactive_tab_edge = theme.colors.tab_bar_bg,
    active_tab = {
      bg_color = theme.colors.active_tab_bg,
      fg_color = theme.colors.active_tab_fg
    },
    inactive_tab = {
      bg_color = theme.colors.inactive_tab_bg,
      fg_color = theme.colors.inactive_tab_fg
    },
    inactive_tab_hover = {
      bg_color = theme.colors.inactive_tab_hover_bg,
      fg_color = theme.colors.inactive_tab_fg
    },
    new_tab = {
      bg_color = theme.colors.tab_bar_bg,
      fg_color = theme.colors.tab_bar_bg
    },
    new_tab_hover = {
      bg_color = theme.colors.tab_bar_bg,
      fg_color = theme.colors.tab_bar_bg
    },
  },
}

config.tab_bar_style = {
  window_hide = utils.colored_icon(
    theme.icons.minimize,
    theme.colors.window_hide_fg
  ),
  window_hide_hover = utils.colored_bold_icon(
    theme.icons.minimize,
    theme.colors.window_hide_fg_hover
  ),
  window_maximize = utils.colored_icon(
    theme.icons.maximize,
    theme.colors.window_max_fg
  ),
  window_maximize_hover = utils.colored_bold_icon(
    theme.icons.maximize,
    theme.colors.window_max_fg_hover
  ),
  window_close = utils.colored_icon(
    theme.icons.close,
    theme.colors.window_close_fg
  ),
  window_close_hover = utils.colored_bold_icon(
    theme.icons.close,
    theme.colors.window_close_fg_hover
  ),
}

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local tab_fg = theme.colors.inactive_tab_fg
  local tab_bg = theme.colors.inactive_tab_bg
  local tab_intensity = 'Normal'
  local left_glyph = tab.tab_index == 0 and theme.dividers.left_most or theme.dividers.left_arrow
  local avail_width = math.max(max_width - 4, 0)
  local raw_title = tab.active_pane.title
  local title = raw_title

  if tab.is_active then
    tab_bg = theme.colors.active_tab_bg
    tab_fg = theme.colors.active_tab_fg
    tab_intensity = 'Bold'
  elseif hover then
    tab_bg = theme.colors.inactive_tab_hover_bg
    tab_intensity = 'Bold'
  end

  if wezterm.column_width(raw_title) > avail_width then
    title = wezterm.truncate_right(raw_title, math.max(avail_width - 1, 0)) .. '…'
  end

  return {
    { Background = { Color = theme.colors.tab_bar_bg } },
    { Foreground = { Color = tab_bg } },
    { Text = left_glyph },
    { Background = { Color = tab_bg } },
    { Foreground = { Color = tab_fg } },
    { Attribute = { Intensity = tab_intensity } },
    { Text = ' ' .. title .. ' ' },
    { Background = { Color = theme.colors.tab_bar_bg } },
    { Foreground = { Color = tab_bg } },
    { Text = theme.dividers.right_arrow },
  }
end)

return config
