local icons = require("icons")
local colors = require("colors")
local settings = require("settings")
local frost = colors.frost

local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    icon = {
        font = {
            family = settings.font.icon.family,
            style = settings.font.style_map["Regular"],
            size = 19.0
        }
    },
    label = {
        font = {
            family = settings.font.numbers
        }
    },
    update_freq = 180,
    popup = {
        align = "center"
    }
})

local remaining_time = sbar.add("item", {
    position = "popup." .. battery.name,
    icon = {
        string = "Time remaining:",
        width = 100,
        align = "left"
    },
    label = {
        string = "??:??h",
        width = 100,
        align = "right"
    }
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
    sbar.exec("pmset -g batt", function(batt_info)
        local icon = "!"
        local label = "?"

        local found, _, charge = batt_info:find("(%d+)%%")
        if found then
            charge = tonumber(charge)
            label = charge .. "%"
        end

        local color = frost[1]
        local charging, _, _ = batt_info:find("AC Power")

        if charging then
            icon = icons.battery.charging
            color = frost[2]
        elseif found then
            if charge > 80 then
                icon = icons.battery._100
                color = frost[1]
            elseif charge > 60 then
                icon = icons.battery._75
                color = frost[2]
            elseif charge > 40 then
                icon = icons.battery._50
                color = frost[3]
            elseif charge > 20 then
                icon = icons.battery._25
                color = frost[4]
            else
                icon = icons.battery._0
                color = colors.with_alpha(frost[4], 0.85)
            end
        end

        local lead = ""
        if found and charge < 10 then
            lead = "0"
        end

        battery:set({
            icon = {
                string = icon,
                color = color
            },
            label = {
                string = lead .. label
            }
        })
    end)
end)

battery:subscribe("mouse.clicked", function(env)
    local drawing = battery:query().popup.drawing
    battery:set({
        popup = {
            drawing = "toggle"
        }
    })

    if drawing == "off" then
        sbar.exec("pmset -g batt", function(batt_info)
            local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
            local label = found and remaining .. "h" or "No estimate"
            remaining_time:set({
                label = label
            })
        end)
    end
end)

sbar.add("bracket", "widgets.battery.bracket", {battery.name}, {
    background = {
        color = colors.bg1,
        border_color = frost[2],
        border_width = 1
    }
})

sbar.add("item", "widgets.battery.padding", {
    position = "right",
    width = settings.group_paddings
})
