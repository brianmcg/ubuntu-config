local wezterm = require 'wezterm'

local M = {}

function M.with_alpha(color, alpha)
  local r, g, b = color:srgba_u8()
  return wezterm.color.parse(string.format('rgba(%d, %d, %d, %d%%)', r, g, b, alpha * 100))
end

function M.blend(color_a, color_b, t)
  local r1, g1, b1 = color_a:srgba_u8()
  local r2, g2, b2 = color_b:srgba_u8()
  return wezterm.color.parse(string.format(
    'rgb(%d, %d, %d)',
    math.floor(r1 + (r2 - r1) * t + 0.5),
    math.floor(g1 + (g2 - g1) * t + 0.5),
    math.floor(b1 + (b2 - b1) * t + 0.5)
  ))
end

function M.padded_icon(icon)
  return icon .. ' '
end

function M.padded_bold_icon(icon)
  return wezterm.format {
    { Attribute = { Intensity = 'Bold' } },
    { Text = M.padded_icon(icon) },
  }
end

function M.colored_icon(icon, color)
  return wezterm.format {
    { Foreground = { Color = color } },
    { Text = M.padded_icon(icon) },
  }
end

function M.colored_bold_icon(icon, color)
  return wezterm.format {
    { Foreground = { Color = color } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = M.padded_icon(icon) },
  }
end

return M
