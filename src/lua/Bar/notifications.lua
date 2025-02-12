local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local App = require("astal.gtk3.app")

return function()
    return Widget.Box({
        Widget.Button({
            class_name = "NotificationButton",
            on_click = App:toggle_window("NotificationCenter"),
            Widget.Icon({
                icon = "preferences-system-notifications"
            })
        }),
    })
end
