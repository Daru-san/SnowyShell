local astal = require("astal")

local Variable = astal.Variable
local Widget = require("astal.gtk3").Widget

local NotificationsList = require('lua.NotificationCenter.Notifications')

local visible = Variable()

local M = {}

function M.toggle()
	if visible then
		visible:set(false)
	else
		visible:set(true)
	end
end

---comment
---@param gdkmonitor any
---@return unknown
function M.Window(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor

	return Widget.Window({
		class_name = "NotificationCenter",
		gdkmonitor = gdkmonitor,
		anchor = Anchor.TOP + Anchor.RIGHT,
		Widget.Box({
			vertical = true,
			visible = visible(),
			Widget.Box({
				Widget.Label({
					class_name = "CenterHeader",
					label = "NotificationCenter",
					halign = "center"
				})
			}),
			NotificationsList()
		}),
	})
end

return M
