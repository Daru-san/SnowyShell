local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local cpu_usage = Variable(0):poll(5000, { "echo 0" }, function(out, prev)
  return tonumber(out)
end)

local ram_usage = Variable(0):poll(5000, { "echo 0" }, function(out, prev)
  return tonumber(out)
end)

return function()
  return Widget.Box({
    class_name = "system",
    Widget.Box({
      Widget.Label({ label = "CPU: " .. tostring(cpu_usage():get()) .. "%" }),
      Widget.CircularProgress({
        value = cpu_usage():get() / 100,
      }),
    }),
    Widget.Box({
      Widget.Label({ label = "MEM: " .. tostring(ram_usage():get()) .. "%" }),
      Widget.CircularProgress({
        value = ram_usage():get() / 100,
      }),
    }),
  })
end
