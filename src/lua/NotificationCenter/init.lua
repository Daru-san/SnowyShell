local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local NotificationsList = require('lua.NotificationCenter.Notifications')
local MusicWidget = require('lua.NotificationCenter.Music')

local App = require("astal.gtk3.app")

---@param gdkmonitor any
---@return unknown
return function(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor

	return Widget.Window({
		name = "NotificationCenter",
		class_name = "NotificationCenter",
		gdkmonitor = gdkmonitor,
		setup = function(self)
			App:add_window(self)
			App:get_window(self.name).visible = false
		end,
		anchor = Anchor.TOP,
		Widget.Box({
			vertical = true,
			Widget.Box({
				halign = "CENTER",
				Widget.Label({
					class_name = "CenterHeader",
					label = "NotificationCenter",
				})
			}),
			MusicWidget(),
			NotificationsList()
		}),
	})
end
