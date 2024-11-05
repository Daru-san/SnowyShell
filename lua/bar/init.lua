local astal = require("astal")
local Widget = require("astal.gtk3.widget")
local Variable = astal.Variable
local GLib = astal.require("GLib")

local Tray = require("lua.bar.tray")
-- local Workspaces = require("lua.bar.workspaces")
local Indicators = require("lua.bar.indicators")
local MediaPlayer = require("lua.bar.media")
local SysStats = require("lua.bar.stats")

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
    anchor = WindowAnchor.TOP + WindowAnchor.LEFT + WindowAnchor.RIGHT,
    exclusivity = "EXCLUSIVE",

    Widget.CenterBox({
      Widget.Box({
        halign = "START",
        -- Workspaces(),
      }),
      Widget.Box({
        MediaPlayer(),
      }),
      Widget.Box({
        halign = "END",
        SysStats(),
        Indicators(),
        Tray(),
        Time("%H:%M:%S"),
      }),
    }),
  })
end
