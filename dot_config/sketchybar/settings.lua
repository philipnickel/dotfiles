local colors = require("colors")
local icons = require("icons")
local frost = colors.frost

return {
    paddings = 2,
    group_paddings = 4,
    modes = {
        main = {
            icon = icons.rebel,
            color = frost[1]
        },
        service = {
            icon = icons.nuke,
            color = frost[4]
        }
    },
    bar = {
        height = 32,
        padding = {
            x = 8,
            y = 0
        },
        background = colors.bar.bg
    },
    items = {
        height = 22,
        gap = 4,
        padding = {
            right = 12,
            left = 10,
            top = 0,
            bottom = 0
        },
        default_color = function(workspace)
            local index = (workspace % #frost) + 1
            return frost[index]
        end,
        highlight_color = function(workspace)
            local index = ((workspace + 1) % #frost) + 1
            return frost[index]
        end,
        colors = {
            background = colors.with_alpha(colors.black, 0.55),
            selected_background = colors.with_alpha(frost[3], 0.45),
            selected_border = frost[3],
            selected_label = colors.white
        },
        corner_radius = 5
    },

    font = {
        text = "MesloLGS NF", -- Used for text
        numbers = "MesloLGS NF", -- Used for numbers
        icon = {
            family = "MesloLGS NF",
            style = "Regular",
            size = 14.0
        },
        app_icons = "sketchybar-app-font:Regular:16.0",
        style_map = {
            ["Regular"] = "Regular",
            ["Semibold"] = "Medium",
            ["Bold"] = "SemiBold",
            ["Heavy"] = "Bold",
            ["Black"] = "ExtraBold"
        }
    }
}
