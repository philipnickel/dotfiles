local colors = require("colors")
local settings = require("settings")
local spaces = require("items.spaces")

local front_app = sbar.add("item", "front_app", {
  display = "active",
  icon = { drawing = false },
  label = {
    font = {
      style = settings.font.style_map["Black"],
      size = 10.0,
    },
  },
  updates = true,
})

if spaces and spaces.register_front_app then
  spaces.register_front_app()
end

front_app:subscribe("front_app_switched", function(env)
  front_app:set({ label = { string = env.INFO } })
end)

front_app:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
