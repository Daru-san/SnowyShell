local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")
local utils = require("snowy_utils")

local mem_usage = utils.mem_usage
local cpu_usage = utils.cpu_usage

local math = require("math")

local function cpu_widget()
  local usage = Variable(0):poll(2000, "sleep 0", function(out, prev)
    return tonumber(cpu_usage())
  end)
  return Widget.Box({
    class_name = "cpu",
    Widget.Label({
      label = bind(usage):as(function(value)
        return tostring("cpu: " .. math.floor(value * 100) .. "%")
      end),
    }),
    on_destroy = function()
      usage:drop()
    end,
  })
end

local function mem_widget()
  local ram_usage = Variable(0):poll(2000, "sleep 0", function(out, prev)
    return tonumber(mem_usage())
  end)
  return Widget.Box({
    class_name = "mem",
    Widget.Label({
      label = bind(ram_usage):as(function(value)
        return tostring("mem: " .. math.floor(value * 100) .. "%")
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
