local astal = require("astal")
local App = require("astal.gtk3.app")

local Bar = require("lua.bar.init")
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
    end
  end,
})
