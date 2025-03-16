local io = require("io")
local string = require("string")
local lib = require("lua.lib")

local M = {}

local cpu = {}

local mem = {}

function cpu.get_info()
	local file = io.open("/proc/stat", "r")

	if file ~= nil then
		local stream = file:read("l")
		while stream ~= nil do
		end
	end
end

function mem.usage()
	local free, total, avail

	for line in io.lines("/proc/meminfo") do
		line = string.gsub(line, "%s+", "")
		line = string.gsub(line, "kB", "")
		local k = string.match(line, "%s*(.-):%d*(.-)")
		local v = string.match(line, "%d+")
		if k == "MemTotal" then
			total = tonumber(v)
			goto continue
		end
		if k == "MemFree" then
			free = tonumber(v)
			goto continue
		end
		if k == "MemAvailable" then
			avail = tonumber(v)
		end
		::continue::
	end

	local used = total - free - avail

	return used, total
end

M.mem = mem
M.cpu = cpu
return M
