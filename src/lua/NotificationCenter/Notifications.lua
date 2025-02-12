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

local function DoNotDisturb()
	return Widget.Box({
		class_name = "NotificationDND",
		halign = "CENTER",
		Widget.Label({
			label = "Do Not Disturb"
		}),
		Widget.Switch({
			on_activate = function(self)
				notifd.set_dont_disturb(self.active)
			end
		})
	})
end

local function clearNotifications()
	return Widget.Box({
		class_name = "NotificationClear",
		halign = "CENTER",
		Widget.Button({
			on_click = function()
				local notifications = notifd.notifications
				for notification in notifications do
					notification.dismiss()
				end
			end,
			Widget.Label({
				label = "Clear notifications",
			})
		})
	})
end

return function()
	local notifs = NotificationMap()
	return Widget.Box({
		class_name = "NotificationCenter",
		vertical = true,
		Widget.Scrollable({
			height_request = 250,
			Widget.Box({
				notifs()
			})
		}),
		clearNotifications(),
		DoNotDisturb()
	})
end
