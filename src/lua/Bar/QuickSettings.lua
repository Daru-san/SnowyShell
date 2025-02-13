local astal = require("astal")
local lib = require('lua.lib')
local bind = astal.bind
local map = lib.map
local Widget = require("astal.gtk3.widget")
local Network = astal.require("AstalNetwork")
local AstalBluetooth = astal.require('AstalBluetooth')
local AudioSlider = require("lua.Bar.Audio")

local function Bluetooth()
  local bluetooth = AstalBluetooth.get_default()

  local button = Widget.Button({
    always_show_image = true,
    tooltip_text = bind(bluetooth, "adapters"):as(function(adapters)
      if lib.tablelen(adapters) == 0 then
        return "No adapters"
      end
      local text = map(adapters, function(adapter)
        local text = adapter.name .. ': '
        text = text .. lib.onoff(adapter)
        bind(bluetooth, "devices"):as(function(devices)
          text = text .. ' connected to ' .. lib.tablelen(devices) ' devices'
        end)
        return text
      end)
      return lib.arrstringline(text)
    end),
    on_click_release = function()
      bluetooth:toggle()
    end,
    image = Widget.Icon({
      class_name = bind(bluetooth, "adapter"):as(function(adapter)
        if not adapter.powered then
          return "BluetoothIconOff"
        end
        bind(bluetooth, "devices"):as(function(devices)
          if lib.tablelen(devices) > 0 then
            return "BluetoothIconConnected"
          else
            return "BluetoothIconOn"
          end
        end)
      end),
      icon = "bluetooth-symbolic"
    })
  })

  return button
end

local function Wifi()
  local wifi = Network.get_default().wifi

  return Widget.Icon({
    tooltip_text = bind(wifi, "ssid"):as(tostring),
    class_name = "Wifi",
    icon = bind(wifi, "icon-name"),
  })
end

return function()
  return Widget.Box({
    class_name = "QuickSettings",
    valign = "CENTER",
    Widget.Box({
      class_name = "QSBox",
      valign = "CENTER",
      halign = "CENTER",
      hexpand = true,
      spacing = 5,
      Wifi(),
      Bluetooth(),
      AudioSlider(),
    }),
  })
end
