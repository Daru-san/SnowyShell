local Widget = require("astal.gtk3.widget")
local astal = require("astal")
local exec = astal.exec

return function()
  return Widget.Button({
    Widget.Icon({
      icon = "preferences-system-notifications",
    }),
    on_click = function()
      exec("swaync-client -t")
    end
  })
end
