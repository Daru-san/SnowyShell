local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local function cpu_widget()
  local cpu_usage = Variable(0):poll(2000, "snowy-utils cpu -d", function(out, prev)
    return tostring(out)
  end)
  return Widget.Box({
    class_name = "cpu",
    Widget.Label({
      label = bind(cpu_usage):as(function(value)
        return tostring("cpu:" .. (value * 100) .. "%")
      end),
    }),
    on_destroy = function()
      cpu_usage:drop()
    end,
  })
end

local function mem_widget()
  local ram_usage = Variable(0):poll(2000, "snowy-utils mem -d", function(out, prev)
    return tonumber(out)
  end)
  return Widget.Box({
    class_name = "mem",
    Widget.Label({
      label = bind(ram_usage):as(function(value)
        return tostring("mem:" .. (value * 100) .. "%")
      end),
    }),
    on_destroy = function()
      ram_usage:drop()
    end,
  })
end

local function net_widget()
  local net_rx = Variable(""):poll(2000, "snowy-utils net -i wlan0 -r", function(out, prev)
    return tostring(out)
  end)

  local net_tx = Variable(""):poll(2000, "snowy-utils net -i wlan0 -t", function(out, prev)
    return tostring(out)
  end)

  return Widget.Box({
    class_name = "net",
    Widget.Label({
      label = bind(net_tx):as(function(value)
        return tostring("rx:" .. value)
      end),
    }),
    Widget.Label({
      label = bind(net_rx):as(function(value)
        return tostring("tx:" .. value)
      end),
    }),
    on_destroy = function()
      net_rx:drop()
      net_tx:drop()
    end,
  })
end

return function()
  return Widget.Box({
    class_name = "stats",
    net_widget(),
    cpu_widget(),
    mem_widget(),
  })
end
