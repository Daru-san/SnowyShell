local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.Bar.init")
local NotifPopups = require("lua.Notifications.popups")
local NotifCenter = require('lua.NotificationCenter.init')
local src = require("lua.lib").src

local scss = src("style.scss")
local css = "/tmp/style.css"

astal.exec("sass " .. scss .. " " .. css)

App:start({
  instance_name = "snowy_shell_lua",
  css = css,
  request_handler = function(msg, res)
    print(msg)
    res("ok")
  end,
  main = function()
    for _, mon in pairs(App.monitors) do
      Bar(mon)
      NotifPopups(mon)
      NotifCenter(mon)
    end
  end,
})
