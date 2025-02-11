local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local App = require("astal.gtk3.app")


return function()
    return Widget.Box({
        Widget.Button({
            class_name = "NotificationButton",
            on_click_release = App.get_window("NotificationCenter").show(),
            Widget.Icon({
                icon = "preferences-system-notifications"
            })
        }),
    })
end
