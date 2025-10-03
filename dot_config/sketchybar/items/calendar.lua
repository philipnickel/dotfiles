local settings = require("settings")
local colors = require("colors")
local icons = require("icons")
local frost = colors.frost

-- Padding item required because of bracket
sbar.add("item", {
    position = "right",
    width = settings.group_paddings
})

local cal = sbar.add("item", {
    icon = {
        color = colors.white,
        padding_left = 8,
        font = {
            family = settings.font.icon.family,
            style = settings.font.icon.style,
            size = 22.0
        },
        string = icons.calendar
    },
    label = {
        color = colors.white,
        padding_right = 8,
        width = 80,
        align = "right",
        font = {
            family = settings.font.text
        }
    },
    position = "right",
    update_freq = 30,
    padding_left = 1,
    padding_right = 1,
    background = {
        color = colors.bg2,
        border_color = frost[2],
        border_width = 1
    }
})

-- Double border for calendar using a single item bracket
-- sbar.add("bracket", { cal.name }, {
--   background = {
--     color = colors.transparent,
--     height = 30,
--     border_color = colors.grey,
--   }
-- })

-- Padding item required because of bracket
sbar.add("item", {
    position = "right",
    width = settings.group_paddings
})

cal:subscribe({"forced", "routine", "system_woke"}, function(env)
    cal:set({
        icon = icons.calendar,
        label = os.date("%m/%d %H:%M")
    })
end)
