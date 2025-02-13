local astal = require("astal")

local lib = require('lua.lib')

local bind = astal.bind
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
			setup = function(self)
				self.active = notifd:get_dont_disturb()
			end,
			on_state_set = function(self)
				notifd:set_dont_disturb(self.active)
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
				local notifications = notifd:get_notifications()
				for _, notification in pairs(notifications) do
					notification.dismiss(notification)
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
			height_request = 200,
			vexpand = true,

			Widget.Box({
				vertical = true,
				vexpand = true,
				hexpand = false,
				spacing = 8,
				notifs(),
				Widget.Box({
					halign = "CENTER",
					valign = "CENTER",
					vertical = true,
					vexpand = true,
					visible = bind(notifd, "notifications"):as(function(n)
						return lib.tablelen(n) == 0
					end),
					Widget.Icon({
						icon = "notifications-disabled-symbolic",
					}),
					Widget.Label({ label = "Inbox is empty" })
				})
			}),
		}),
		clearNotifications(),
		DoNotDisturb()
	})
end
