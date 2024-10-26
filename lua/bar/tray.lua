local astal = require("astal")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")

local Tray = astal.require("AstalTray")
local tray = Tray.get_default()

local Gdk = astal.require("Gdk", "3.0")
local App = require("astal.gtk3.app")

local map = require("lua.lib").map

return function()
  return Widget.Box({
    bind(tray, "items"):as(function(items)
      return map(items, function(item)
        if item.icon_theme_path ~= nil then
          App:add_icons(item.icon_theme_path)
        end

        local menu = item:create_menu()

        return Widget.Button({
          tooltip_markup = bind(item, "tooltip_markup"),
          on_destroy = function()
            if menu ~= nil then
              menu:destroy()
            end
          end,
          on_click_release = function(self)
            if menu ~= nil then
              menu:popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, nil)
            end
          end,
          Widget.Icon({
            g_icon = bind(item, "gicon"),
          }),
        })
      end)
    end),
  })
end
