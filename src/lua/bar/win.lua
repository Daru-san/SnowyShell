local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local function full_widget(gdkmonitor)
  local WindowAnchor = astal.require("Astal", "3.0").WindowAnchor

  return Widget.Window({
    class_name = "win",
    gdkmonitor = gdkmonitor,
    anchor = WindowAnchor.TOP + WindowAnchor.RIGHT,
    visible = false,
    Widget.Box({
      vertical = true,
      Widget.Box({
        class_name = "networks",
        Widget.Box({
          -- networks
        }),
        Widget.Box({
          -- bluetooth
        })
      }),
      Widget.Box({
        class_name = "misc",
        Widget.Box({
          -- caffine
        }),
        Widget.Box({
          -- power profiles // power
        })
      }),
      Widget.Box({
        class_name = "stats?"
      })
    })
  })
end

return full_widget
