local astal = require("astal")

local Widget = require("astal.gtk3").Widget

local NotificationCenter = require('lua.NotificationCenter.init')

return function()
    return Widget.Button({
        class_name = "NotificationButton",
        on_clicked = NotificationCenter.toggle()
    })
end
