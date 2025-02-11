local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local Notifd = astal.require("AstalNotifd")
local Notification = require("lua.Notifications.init")

local varmap = require("lua.lib").varmap
local notifd = Notifd.get_default()

local function NotificationMap()
	local notif_map = varmap({})

	notifd.on_notified = function(_, id)
		notif_map.set(
			id,
			Notification({
				notification = notifd:get_notification(id),
			})
		)
	end

	notifd.on_resolved = function(_, id) notif_map.delete(id) end

	return notif_map
end

return function()
	local notifs = NotificationMap()
	return Widget.Box({
		class_name = "NotificationCenter",
		vertical = true,
		notifs()
	})
end
