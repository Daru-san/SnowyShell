local astal = require("astal")
local Widget = require("astal.gtk3").Widget

local Notifd = astal.require("AstalNotifd")
local Notification = require("lua.notif.init")
local timeout = astal.timeout

local TIMEOUT_DELAY = 5000

local varmap = require("lua.lib").varmap
local notifd = Notifd.get_default()

local function NotificationMap()
	local notif_map = varmap({})

	notifd.on_notified = function(_, id)
		notif_map.set(
			id,
			Notification({
				notification = notifd:get_notification(id),
				on_hover_lost = function() notif_map.delete(id) end,
				setup = function()
					timeout(TIMEOUT_DELAY, function()
						NotificationMap.delete(id)
					end)
				end,
			})
		)
	end

	notifd.on_resolved = function(_, id) notif_map.delete(id) end

	return notif_map
end

return function(gdkmonitor)
	local Anchor = astal.require("Astal").WindowAnchor
	local notifs = NotificationMap()

	return Widget.Window({
		class_name = "NotificationPopups",
		gdkmonitor = gdkmonitor,
		anchor = Anchor.TOP + Anchor.RIGHT,
		Widget.Box({
			vertical = true,
			notifs(),
		}),
	})
end
