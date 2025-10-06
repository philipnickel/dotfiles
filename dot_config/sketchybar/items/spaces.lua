local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

sbar.add("event", "aerospace_workspace_change")
sbar.add("event", "aerospace_monitor_change")

local workspaces = {}
local workspace_brackets = {}
local workspace_ids = {}

local function trim(value)
  if not value then return "" end
  return (value:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function split_lines(value)
  local lines = {}
  if not value then return lines end
  for line in value:gmatch("[^\r\n]+") do
    local normalized = trim(line)
    if normalized ~= "" then
      table.insert(lines, normalized)
    end
  end
  return lines
end

local function icon_for_app(app)
  return app_icons[app] or app_icons["Default"] or app
end

local function update_workspace_icons(id)
  local item = workspaces[id]
  if not item then return end

  sbar.exec("aerospace list-windows --workspace " .. id .. " --format \"%{app-name}\"", function(output)
    local icon_line = ""
    local count = 0
    for app in string.gmatch(output or "", "[^\r\n]+") do
      local name = trim(app)
      if name ~= "" then
        icon_line = icon_line .. icon_for_app(name)
        count = count + 1
      end
    end
    if count == 0 then
      icon_line = " —"
    end
    item:set({ label = icon_line })
  end)
end

local function update_all_workspace_icons()
  for _, id in ipairs(workspace_ids) do
    update_workspace_icons(id)
  end
end

local function apply_focus_state(focused)
  if not focused then return end
  local focused_id = tostring(focused)
  for _, id in ipairs(workspace_ids) do
    local item = workspaces[id]
    if item then
      local selected = tostring(id) == focused_id
      item:set({
        icon = {
          color = selected and colors.red or colors.white,
        },
        label = {
          color = selected and colors.white or colors.grey,
        },
        background = {
          border_color = selected and colors.black or colors.bg2,
        },
      })
    end
    local bracket = workspace_brackets[id]
    if bracket then
      local selected = tostring(id) == focused_id
      bracket:set({
        background = {
          border_color = selected and colors.grey or colors.bg2,
        },
      })
    end
  end
end

local function refresh_focus()
  sbar.exec("aerospace list-workspaces --focused", function(output)
    local focused = trim(output or "")
    if focused == "" then
      focused = workspace_ids[1]
    end
    if focused then
      apply_focus_state(focused)
    end
  end)
end

local function ensure_workspace_item(id)
  if not id or id == "" or workspaces[id] then
    return
  end

  local item = sbar.add("item", "space." .. id, {
    position = "left",
    icon = {
      font = { family = settings.font.numbers },
      string = id,
      padding_left = 12,
      padding_right = 6,
      color = colors.white,
    },
    label = {
      padding_right = 14,
      color = colors.grey,
      font = "sketchybar-app-font:Regular:13.0",
      y_offset = -1,
    },
    padding_left = 1,
    padding_right = 1,
    background = {
      color = colors.bg1,
      border_width = 1,
      height = 22,
      border_color = colors.bg2,
    },
    updates = true,
  })

  workspaces[id] = item
  table.insert(workspace_ids, id)
  table.sort(workspace_ids, function(a, b)
    return tonumber(a) < tonumber(b)
  end)

  local bracket = sbar.add("bracket", { item.name }, {
    background = {
      color = colors.transparent,
      border_color = colors.bg2,
      height = 24,
      border_width = 1,
    },
  })
  workspace_brackets[id] = bracket

  sbar.add("item", "space.padding." .. id, {
    position = "left",
    width = settings.group_paddings,
  })

  item:subscribe("mouse.clicked", function(env)
    if env.BUTTON ~= "left" then
      return
    end
    sbar.exec("aerospace workspace " .. id)
    apply_focus_state(id)
  end)
end

local function bootstrap_workspaces()
  sbar.exec("aerospace list-workspaces --all", function(output)
    local ids = split_lines(output)
    if #ids == 0 then
      ids = { "1", "2", "3", "4", "5", "6" }
    end
    for _, id in ipairs(ids) do
      ensure_workspace_item(id)
    end
    update_all_workspace_icons()
    refresh_focus()
  end)
end

bootstrap_workspaces()

local workspace_observer = sbar.add("item", {
  drawing = false,
  updates = true,
})

workspace_observer:subscribe("aerospace_workspace_change", function(env)
  local focused = trim(env.FOCUSED_WORKSPACE)
  if focused == "" then
    refresh_focus()
  else
    ensure_workspace_item(focused)
    apply_focus_state(focused)
  end
  update_all_workspace_icons()
end)

workspace_observer:subscribe("aerospace_monitor_change", function(_)
  update_all_workspace_icons()
  refresh_focus()
end)

workspace_observer:subscribe("front_app_switched", function(_)
  update_all_workspace_icons()
end)

workspace_observer:subscribe("space_windows_change", function(_)
  update_all_workspace_icons()
end)

workspace_observer:subscribe("system_woke", function(_)
  update_all_workspace_icons()
  refresh_focus()
end)

local spaces_indicator = sbar.add("item", {
  padding_left = -3,
  padding_right = 0,
  icon = {
    padding_left = 8,
    padding_right = 9,
    color = colors.grey,
    string = icons.switch.on,
  },
  label = {
    width = 0,
    padding_left = 0,
    padding_right = 8,
    string = "Spaces",
    color = colors.bg1,
  },
  background = {
    color = colors.with_alpha(colors.grey, 0.0),
    border_color = colors.with_alpha(colors.bg1, 0.0),
  },
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
  local currently_on = spaces_indicator:query().icon.value == icons.switch.on
  spaces_indicator:set({
    icon = currently_on and icons.switch.off or icons.switch.on,
  })
end)

spaces_indicator:subscribe("mouse.entered", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 1.0 },
        border_color = { alpha = 1.0 },
      },
      icon = { color = colors.bg1 },
      label = { width = "dynamic" },
    })
  end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
  sbar.animate("tanh", 30, function()
    spaces_indicator:set({
      background = {
        color = { alpha = 0.0 },
        border_color = { alpha = 0.0 },
      },
      icon = { color = colors.grey },
      label = { width = 0 },
    })
  end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
  sbar.trigger("swap_menus_and_spaces")
end)
