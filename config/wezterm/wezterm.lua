local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

local theme = 'Argonaut (Gogh)'

-- Appearance
config.color_scheme = theme

-- get_builtin_schemes() returns plain hex strings, not Color objects; parse()
-- them to get lighten()/darken() etc.
local ubuntu_scheme = wezterm.color.get_builtin_schemes()[theme]
local scheme_bg = wezterm.color.parse(ubuntu_scheme.background)

-- Background: the theme's own background color as a solid base layer, with
-- the image layered on top at partial opacity so it reads as a faint
-- watermark tinted by the theme rather than a washed-out photo. This
-- replaces the old approach of darkening the image itself (hsb.brightness),
-- which made it look dim/muddy instead of blended with the theme.
config.background = {
  {
    source = { Color = ubuntu_scheme.background },
    width = '100%',
    height = '100%',
  },
  {
    source = { File = wezterm.config_dir .. '/images/gradient-hexagons.jpg' },
    horizontal_align = 'Center',
    vertical_align = 'Middle',
    width = 'Cover',
    height = 'Cover',
    opacity = 0.1,
  },
}

-- config.window_background_opacity = 0.7
-- Retro tab bar (see use_fancy_tab_bar below) renders at this same font/size,
-- so the window-control icon glyphs come out at full 16pt too, looking
-- oversized against the icons' own generous internal padding. Scaling down
-- just the "Symbols Nerd Font Mono" fallback (the font those icon codepoints
-- resolve from — verified via `wezterm ls-fonts --codepoints eaba,eab9,ea76`)
-- shrinks only them, leaving normal text at the requested 16pt.
config.font = wezterm.font_with_fallback {
  'Ubuntu Mono',
  { family = 'Symbols Nerd Font Mono', scale = 0.45 },
}
config.font_size = 16.0
config.default_cursor_style = 'BlinkingBlock'
-- Default blink fades in/out; 'Constant' makes it a hard on/off toggle instead.
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
-- Default max tab width (16 cells) truncates titles quickly; widen it so
-- longer titles have room before format-tab-title's truncate_right kicks in.
config.tab_max_width = 24

-- Tab bar background matches the scheme's terminal background (Ubuntu's
-- signature aubergine, #300a24) instead of WezTerm's own default, so the
-- bar reads as one continuous surface with the terminal below it.

-- Fully transparent stand-in for scheme_bg, used everywhere the bar's empty
-- space (and the powerline dividers' backdrop gutters, which are also drawn
-- in this color) should show the background image through instead of a
-- solid fill. Tab pills themselves are opaque colors derived from the
-- scheme's ansi yellow/white (see active_tab_bg/inactive_tab_bg below), not
-- from scheme_bg, so they read as distinct from this transparent backdrop.
local function with_alpha(color, alpha)
  local r, g, b = color:srgba_u8()
  return wezterm.color.parse(string.format('rgba(%d, %d, %d, %d%%)', r, g, b, alpha * 100))
end
local tab_bar_bg = with_alpha(scheme_bg, 0)

-- ansi[1]/[4]/[8] are the scheme's normal-intensity black/yellow/white
-- (1-indexed: black, red, green, yellow, blue, magenta, cyan, white).
local scheme_black = wezterm.color.parse(ubuntu_scheme.ansi[1])
local scheme_yellow = wezterm.color.parse(ubuntu_scheme.ansi[4])
local scheme_white = wezterm.color.parse(ubuntu_scheme.ansi[8])

local active_tab_bg = scheme_yellow
local inactive_tab_bg = scheme_white:darken(0.2)
-- brights[8] (the theme's "bright white") is identical to ansi[8] on some
-- schemes (e.g. LiquidCarbonTransparent), which would make hover invisible;
-- lighten() guarantees a visible change regardless of the scheme.
local inactive_tab_hover_bg = scheme_white:lighten(0.35)

config.window_frame = {
  active_titlebar_bg = tab_bar_bg,
  inactive_titlebar_bg = tab_bar_bg,
  -- Keep the window-control buttons' background constant on hover instead
  -- of lightening (bold-on-hover is done in tab_bar_style below instead).
  button_bg = tab_bar_bg,
  button_hover_bg = tab_bar_bg,
  -- Reuses inactive_tab_bg/inactive_tab_hover_bg's darken()/lighten() amounts
  -- so icon and tab resting/hover states stay visually consistent.
  button_fg = inactive_tab_bg,
  button_hover_fg = inactive_tab_hover_bg,
}

config.colors = {
  tab_bar = {
    background = tab_bar_bg,
    -- Defaults to a fixed grey (#575757) independent of the scheme, showing
    -- as a stray grey line between tabs; blend it into the (now transparent)
    -- bar instead.
    inactive_tab_edge = tab_bar_bg,
    active_tab = { bg_color = active_tab_bg, fg_color = scheme_black },
    inactive_tab = { bg_color = inactive_tab_bg, fg_color = scheme_black },
    inactive_tab_hover = { bg_color = inactive_tab_hover_bg, fg_color = scheme_black },
    new_tab = { bg_color = tab_bar_bg, fg_color = inactive_tab_bg },
    -- Same background as non-hover (was inactive_tab_hover_bg, a lighter
    -- tint); bold instead of a background-lightening hover effect.
    new_tab_hover = { bg_color = tab_bar_bg, fg_color = inactive_tab_hover_bg, intensity = 'Bold' },
  },
}

-- INTEGRATED_BUTTONS window controls default to plain caret glyphs, which
-- look out of place next to the powerline tabs. Swap in Nerd Font codicons
-- instead. Named wezterm.nerdfonts constants for these don't exist in this
-- build, so referenced by codepoint directly (verified via
-- `wezterm ls-fonts --codepoints ea76,eaba,eab9`, resolved from WezTerm's
-- own bundled Symbols Nerd Font Mono, no external font needed).
local ICON_MINIMIZE = utf8.char(0xf05b0) -- nf-cod-chrome_minimize
local ICON_MAXIMIZE = utf8.char(0xf05af) -- nf-cod-chrome_maximize
local ICON_CLOSE = utf8.char(0xf0156) -- nf-cod-chrome_close
local ICON_PLUS = utf8.char(0xf0415) -- nf-md-plus

-- Padded with spaces on both sides: these glyphs render wider than the
-- single cell WezTerm allots each button, so without padding adjacent
-- buttons visually overlap.
local function padded_icon(icon)
  return ' ' .. icon .. ' '
end

-- Hover variant: same padded icon, but bold instead of WezTerm's default
-- background-lightening hover effect (background itself is neutralized via
-- window_frame.button_hover_bg above).
local function padded_bold_icon(icon)
  return wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Text = padded_icon(icon) },
  }
end

config.tab_bar_style = {
  window_hide = padded_icon(ICON_MINIMIZE),
  window_hide_hover = padded_bold_icon(ICON_MINIMIZE),
  window_maximize = padded_icon(ICON_MAXIMIZE),
  window_maximize_hover = padded_bold_icon(ICON_MAXIMIZE),
  window_close = padded_icon(ICON_CLOSE),
  window_close_hover = padded_bold_icon(ICON_CLOSE),
  new_tab = padded_icon(ICON_PLUS),
  new_tab_hover = padded_bold_icon(ICON_PLUS),
}

-- Powerline "hard divider" triangles instead of flat tab edges: each tab is
-- capped left/right with a triangle glyph whose foreground is that tab's own
-- background color, drawn on the bar's background color, so it reads as a
-- pointed pill shape rather than a rectangle. config.tab_bar_style's
-- per-tab left/right fields don't exist in this WezTerm build (added after
-- 20240203), so this is built by hand via the older format-tab-title event
-- instead, which has been stable since much earlier releases.
-- wezterm.nerdfonts.pl_left_hard_divider_inverse doesn't exist as a named
-- constant in this WezTerm build (same version-gap issue as tab_bar_style);
-- reference its codepoint (U+E0D7) directly instead. Unlike the plain hard
-- dividers, this one isn't drawn natively by WezTerm and needs an actual
-- font glyph — confirmed present via `wezterm ls-fonts --codepoints e0d7`,
-- resolved from the installed 0xProto Nerd Font Propo through WezTerm's
-- automatic system-font fallback.
-- local SOLID_LEFT_ARROW = utf8.char(0xe0d7)
-- local SOLID_RIGHT_ARROW = wezterm.nerdfonts.pl_left_hard_divider


local SOLID_LEFT_ARROW = utf8.char(0xe0ba)
local SOLID_LEFT_MOST = utf8.char(0x2588)
local SOLID_RIGHT_ARROW = utf8.char(0xe0bc)

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  -- Text is always theme black, regardless of tab state; only the pill
  -- background/weight change below.
  local tab_fg = scheme_black

  local tab_bg = inactive_tab_bg
  local tab_intensity = 'Normal'
  if tab.is_active then
    tab_bg = active_tab_bg
    tab_intensity = 'Bold'
  elseif hover then
    tab_bg = inactive_tab_hover_bg
    tab_intensity = 'Bold'
  end

  -- Room for the padding spaces and powerline arrows on either side of the
  -- title (see the returned table below). Clamped to 0 so a pathologically
  -- narrow tab (many tabs open) can't pass a negative width to truncate_right.
  local avail_width = math.max(max_width - 4, 0)
  local raw_title = tab.active_pane.title
  local title = raw_title
  if wezterm.column_width(raw_title) > avail_width then
    title = wezterm.truncate_right(raw_title, math.max(avail_width - 1, 0)) .. '…'
  end
  local left_glyph = tab.tab_index == 0 and SOLID_LEFT_MOST or SOLID_LEFT_ARROW

  return {
    { Background = { Color = tab_bar_bg } },
    { Foreground = { Color = tab_bg } },
    { Text = left_glyph },
    { Background = { Color = tab_bg } },
    { Foreground = { Color = tab_fg } },
    { Attribute = { Intensity = tab_intensity } },
    { Text = ' ' .. title .. ' ' },
    { Background = { Color = tab_bar_bg } },
    { Foreground = { Color = tab_bg } },
    { Text = SOLID_RIGHT_ARROW },
  }
end)

-- No native title bar: GNOME/Mutter under Wayland can't give WezTerm a real
-- server-side one, so its fallback CSD title bar shows square corners, caret
-- min/max icons, and a titlebar-border color that doesn't match the color
-- scheme. INTEGRATED_BUTTONS draws minimize/maximize/close into the tab bar
-- itself instead, so there's still window control buttons without the
-- separate title bar strip. Tab bar kept visible even with one tab so it's
-- always there as the drag handle.
config.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
config.hide_tab_bar_if_only_one_tab = false

-- This WezTerm build has no `show_close_tab_button_in_tabs` toggle (added in
-- a later version than this install); in fancy tab bar mode it always
-- appends its own close 'x' after format-tab-title's output, with no way to
-- suppress it. Retro tab bar mode instead renders format-tab-title's return
-- value as the tab's entire content with nothing auto-appended, which is
-- WezTerm's own documented workaround for this exact limitation.
-- INTEGRATED_BUTTONS window controls still work in retro mode.
config.use_fancy_tab_bar = false

-- Keybindings (mirroring Terminator muscle memory)
config.keys = {
  { key = 't', mods = 'CTRL|SHIFT', action = act.SpawnTab 'CurrentPaneDomain' },

  -- Terminator's "horizontal split" stacks panes top/bottom, opposite of
  -- WezTerm's SplitHorizontal (left/right) naming — mapped here by visual
  -- result, not by WezTerm's literal action name.
  { key = 'o', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Down' } },
  { key = 'e', mods = 'CTRL|SHIFT', action = act.SplitPane { direction = 'Right' } },

  -- Overrides WezTerm's default Ctrl+Shift+W (CloseCurrentTab), which closes
  -- the whole tab — and with only one tab open, the whole window. This closes
  -- just the focused pane instead.
  { key = 'w', mods = 'CTRL|SHIFT', action = act.CloseCurrentPane { confirm = false } },

  -- Pane navigation
  { key = 'LeftArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'RightArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },
  { key = 'UpArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'DownArrow', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
}

return config
