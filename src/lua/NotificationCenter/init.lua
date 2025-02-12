local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local NotificationsList = require('lua.NotificationCenter.Notifications')

local App = require("astal.gtk3.app")

---@param gdkmonitor any
---@return unknown
return function(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor

	return Widget.Window({
		class_name = "NotificationCenter",
		name = "NotificationCenter",
		gdkmonitor = gdkmonitor,
		setup = function(self)
			App:add_window(self)
		end,
		anchor = Anchor.TOP + Anchor.RIGHT,
		Widget.Box({
			vertical = true,
			visible = false,
			Widget.Box({
				Widget.Label({
					class_name = "CenterHeader",
					label = "NotificationCenter",
				})
			}),
			NotificationsList()
		}),
	})
end
