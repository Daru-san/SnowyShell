local astal = require("astal")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")

local niri = astal.require("AstalNiri").get_default()

local map = require("lua.lib").map

return function()
  return Widget.Box({
    class_name = "workspaces",
    bind(niri, "workspaces"):as(function(wss)
      map(wss, function(ws)
        return Widget.Button({
          label = bind(ws, "idx"):as(function(v)
            return string.format("%.0f", v)
          end),
        })
      end)
    end),
  })
end
