local astal = require("astal")
local Variable = astal.Variable
local bind = astal.bind

local Widget = require("astal.gtk3.widget")

local Wp = astal.require("AstalWp")

local speaker = Wp.get_default().audio.default_speaker


return function()
  return Widget.EventBox({
    class_name = "Volume",
    tooltip_text = bind(speaker, "volume"):as(function(v)
      return string.format("%.0f%%", v * 100)
    end),
    on_scroll = function(_, event)
      if event.delta_y < -1 then
        speaker.volume = math.min(speaker.volume + 0.05, 1)
      elseif event.delta_y > -1 then
        speaker.volume = math.max(speaker.volume - 0.05, 0)
      end
    end,
    Widget.Box({
      Widget.Button({
        on_click_release = function()
          speaker.mute = not speaker.mute
        end,
        always_show_image = true,
        image = Widget.Icon({
          class_name = "icon",
          icon = bind(speaker, "volume-icon"),
        }),
        label = bind(speaker, "volume"):as(function(v)
          return string.format("%.0f%%", v * 100)
        end)
      }),
      Widget.Slider({
        class_name = "audio-slider",
        on_dragged = function(self)
          speaker.volume = self.value
        end,
        hexpand = true,
        value = bind(speaker, "volume"),
      }),
    }),
  })
end
