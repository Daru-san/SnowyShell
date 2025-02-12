local astal = require("astal")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")
local Network = astal.require("AstalNetwork")
local AudioSlider = require("lua.Bar.audio")

local function Wifi()
  local wifi = Network.get_default().wifi

  return Widget.Icon({
    tooltip_text = bind(wifi, "ssid"):as(tostring),
    class_name = "Wifi",
    icon = bind(wifi, "icon-name"),
  })
end

return function()
  return Widget.Box({
    class_name = "widget-box",
    valign = "CENTER",
    Widget.Box({
      class_name = "indicator-box",
      valign = "CENTER",
      halign = "CENTER",
      hexpand = true,
      spacing = 5,
      Wifi(),
      AudioSlider(),
    }),
  })
end
