local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local GLib = astal.require("GLib")

local Tray = require("lua.Bar.Tray")
local Workspaces = require("lua.Bar.Workspaces")
local QuickSettings = require("lua.Bar.QuickSettings")
local SysStats = require("lua.Bar.Statistics")
local NotifButton = require("lua.Bar.NotificationButton")
local Media = require("lua.Bar.media")

local function Time(format)
	local time = Variable(""):poll(1000, function()
		return GLib.DateTime.new_now_local():format(format)
	end)

	return Widget.Label({
		class_name = "Time",
		on_destroy = function()
			time:drop()
		end,
		label = time(),
	})
end

return function(gdkmonitor)
	local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

	return Widget.Window({
		class_name = "Bar",
		gdkmonitor = gdkmonitor,
		anchor = WindowAnchor.BOTTOM + WindowAnchor.LEFT + WindowAnchor.RIGHT,
		exclusivity = "EXCLUSIVE",

		Widget.CenterBox({
			Widget.Box({
				halign = "START",
				Time("%A, %d %B [%X]"),
				NotifButton(),
				Media(),
			}),
			Widget.Box({
				Workspaces(),
			}),
			Widget.Box({
				halign = "END",
				Tray(),
				QuickSettings(),
				SysStats(),
			}),
		}),
	})
end
