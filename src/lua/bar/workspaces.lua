local astal = require("astal")
local bind = astal.bind
local Widget = require("astal.gtk3.widget")

local Hyprland = astal.require("AstalHyprland")
local hypr = Hyprland.get_default()

local map = require("lua.lib").map

return function()
  return Widget.Box({
    class_name = "workspaces",
    bind(hypr, "workspaces"):as(function(wss)
      table.sort(wss, function(a, b)
        return a.id < b.id
      end)

      return map(wss, function(ws)
        return Widget.Button({
          class_name = bind(hypr, "focused-workspace"):as(function(fw)
            return fw == ws and "focused" or ""
          end),
          on_clicked = function()
            ws:focus()
          end,
          label = bind(ws, "id"):as(function(v)
            return type(v) == "number" and string.format("%.0f", v) or v
          end),
        })
      end)
    end),
  })
end
