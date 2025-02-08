local astal = require("astal")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")

local Tray = astal.require("AstalTray")
local tray = Tray.get_default()

local map = require("lua.lib").map

return function()
  return Widget.Box({
    class_name = "tray",
    bind(tray, "items"):as(function(items)
      return map(items, function(item)
        return Widget.MenuButton({
          tooltip_markup = bind(item, "tooltip_markup"),
          use_popover = false,
          menu_model = bind(item, "menu-model"),
          action_group = bind(item, "action-group"):as(
            function(ag) return { "dbusmenu", ag } end
          ),
          Widget.Icon({
            gicon = bind(item, "gicon"),
          }),
        })
      end)
    end),
  })
end
