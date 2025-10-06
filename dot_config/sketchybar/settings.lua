local icon_set = "NerdFont"

local font
if icon_set == "NerdFont" then
  font = {
    text = "JetBrainsMono Nerd Font",
    numbers = "JetBrainsMono Nerd Font",
    style_map = {
      ["Regular"] = "Regular",
      ["Semibold"] = "Medium",
      ["Bold"] = "SemiBold",
      ["Heavy"] = "Bold",
      ["Black"] = "ExtraBold",
    },
  }
else
  font = require("helpers.default_font")
end

return {
  paddings = 2,
  group_paddings = 4,

  icons = icon_set,
  font = font,
}
