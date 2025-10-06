local colors = require("colors")

-- Equivalent to the --bar domain
sbar.bar({
  height = 35,
  margin = 0,
  border_width = 0,
  border_color = colors.white,
  y_offset = 0,
  color = colors.bar.bg,
  padding_right = 0,
  padding_left = 0,
  corner_radius = 7,
  blur_radius = 10,
})
