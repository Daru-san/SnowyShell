local Notifd = require("lgi").require("AstalNotifd")
local notifd = Notifd.get_default()
local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable


local function notification(n)
  local summary = Widget.Label({
    label = n.summary,
    class_name = "notif-summary",
  })
  local body = Widget.Label({
    label = n.body,
    class_name = "notif-body",
  })
  local title_box = Widget.Box({
    orientation = "VERTICAL",
    class_name = "notif-title",
    Widget.Icon({
      icon = n.app_icon,
      class_name = "notif-title-icon",
    }),
    Widget.Label({
      label = n.app_name,
      class_name = "notif-title-label",
    })
  })
  local summary_box = Widget.Box({
    orientation = "VERTICAL",
    class_name = "notif-summary-box",
    summary(),
    body()
  })
  return Widget.EventBox({
    class_name = "notif-box",
    title_box(),
    summary_box(),
  })
end

local function notif_window()
  return Widget.Window({
    visible = false,
    notification()
  })
end
return notif_window()
