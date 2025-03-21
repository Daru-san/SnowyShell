local Variable = require("astal").Variable

local astal = require('astal')
local Gtk = require("astal.gtk3").Gtk
local GLib = astal.require("GLib")

local M = {}

function M.src(path)
  local str = debug.getinfo(2, "S").source:sub(2)
  local src = str:match("(.*/)") or str:match("(.*\\)") or "./"
  return src .. path
end

---@generic T, R
---@param arr T[]
---@param func fun(T, integer): R
---@return R[]
function M.map(arr, func)
  local new_arr = {}
  for i, v in ipairs(arr) do
    new_arr[i] = func(v, i)
  end
  return new_arr
end

M.date = Variable(""):poll(1000, "date")

---@param path string
---@return boolean
function M.file_exists(path) return GLib.file_test(path, "EXISTS") end

---@param time number
---@param format? string
function M.time(time, format)
  format = format or "%H:%M"
  return GLib.DateTime.new_from_unix_local(time):format(format)
end

function M.varmap(initial)
  local map = initial
  local var = Variable()

  local function notify()
    local arr = {}
    for _, value in pairs(map) do
      table.insert(arr, value)
    end
    var:set(arr)
  end

  local function delete(key)
    if Gtk.Widget:is_type_of(map[key]) then map[key]:destroy() end

    map[key] = nil
  end

  notify()

  return setmetatable({
    set = function(key, value)
      delete(key)
      map[key] = value
      notify()
    end,
    delete = function(key)
      delete(key)
      notify()
    end,
    get = function() return var:get() end,
    subscribe = function(callback) return var:subscribe(callback) end,
  }, {
    __call = function() return var() end,
  })
end

---@param table table
---@return number
function M.tablelen(table)
  local count = 0
  for _ in pairs(table) do
    count = count + 1
  end
  return count
end

---@param table table
---@return nil
function M.printfields(table)
  for k, v in pairs(table) do
    print(k, v)
  end
end

---@param bool boolean
---@return string
function M.onoff(bool)
  if bool then
    return "on"
  else
    return "off"
  end
end

---@param arr table
---@return string
function M.arrstringline(arr)
  local text = ''
  for _, item in pairs(arr) do
    if text == '' then
      text = item
    else
      text = text .. '\n' .. item
    end
  end
  return text
end

---@param arr table
---@return string
function M.arrstring(arr)
  local text = ''
  for _, item in pairs(arr) do
    text = text .. ' ' .. item
  end
  return text
end

return M
