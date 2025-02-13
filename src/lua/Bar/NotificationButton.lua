local astal = require("astal")

local bind = astal.bind

local lib = require('lua.lib')

local Widget = require("astal.gtk3").Widget

local Notifd = astal.require("AstalNotifd")
local notifd = Notifd.get_default()

local App = require("astal.gtk3.app")

return function()
    return Widget.Box({
        Widget.Button({
            class_name = "NotificationButton",
            on_clicked = function()
                App:toggle_window("NotificationCenter")
            end,
            always_show_image = true,
            image = Widget.Icon({
                icon = bind(notifd, "dont-disturb"):as(function(dnd)
                    if dnd then
                        return "notifications-disabled-symbolic"
                    else
                        return "notifications-symbolic"
                    end
                end)
            }),
            label = bind(notifd, "notifications"):as(function(notifs)
                return tostring(lib.tablelen(notifs))
            end),
        }),
    })
end
