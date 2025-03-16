local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local utils = require("sysinfo")
local cpu = utils.cpu
local mem = utils.memory
local net = utils.network
local sys = require("lua.utils.sys")

local math = require("std.math")
local string = require("std.string")

local function cpu_widget()
	local usage = Variable(0):poll(2000, function()
		return tonumber(cpu.cpu_usage())
	end)
	return Widget.Box({
		class_name = "CPU",
		Widget.Label({
			label = bind(usage):as(function(value)
				return tostring(math.round(value * 100, 0) .. "%")
			end),
		}),
		on_destroy = function()
			usage:drop()
		end,
	})
end

local function mem_widget()
	local ram_usage = Variable(0):poll(2000, function()
		local used, total = sys.mem.usage()
		return tostring((math.round(used / 1000)) .. "MiB" .. "/" .. tostring(math.round(total / 1000)) .. "MiB")
	end)
	return Widget.Box({
		class_name = "Memory",
		Widget.Label({
			label = bind(ram_usage):as(function(value)
				return tostring(value)
			end),
		}),
		on_destroy = function()
			ram_usage:drop()
		end,
	})
end

local function net_widget()
	local iface = "wlan0"

	local net_rx = Variable(0):poll(500, function()
		return tonumber(net.rx_bytes(iface))
	end)

	local net_tx = Variable(0):poll(500, function()
		return tonumber(net.tx_bytes(iface))
	end)

	return Widget.Box({
		class_name = "Network",
		Widget.Label({
			label = bind(net_tx):as(function(rx)
				bind(net_tx):as(function(tx)
					return tostring(string.numbertosi(rx) .. "bps" + string.numbertosi(tx) .. "bps")
				end)
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
		class_name = "Statistics",
		Widget.Icon({
			icon = "utilities-system-monitor-symbolic",
		}),
		-- net_widget(),
		cpu_widget(),
		mem_widget(),
	})
end
