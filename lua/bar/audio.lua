local astal = require("astal")
local Variable = astal.Variable
local bind = astal.bind

local Widget = require("astal.gtk3.widget")

local Wp = astal.require("AstalWp")

local speaker = Wp.get_default().audio.default_speaker

local scroll_revealed = Variable()

return function()
  return Widget.EventBox({
    on_hover = function()
      scroll_revealed:set(true)
    end,
    on_hover_lost = function()
      scroll_revealed:set(false)
    end,
    tooltip_text = bind(speaker, "volume"):as(function(v)
      return string.format("%.0f%%", v * 100)
    end),
    on_scroll = function(_, event)
      if event.delta_y < -1 then
        speaker.volume = speaker.volume + 0.05
      elseif event.delta_y > -1 then
        speaker.volume = speaker.volume - 0.05
      end
    end,
    Widget.Box({
      Widget.Revealer({
        reveal_child = scroll_revealed(),
        transition_type = "SLIDE_LEFT",
        valign = "CENTER",
        Widget.Slider({
          class_name = "audio-slider",
          on_dragged = function(self)
            speaker.volume = self.value
          end,
          hexpand = true,
          value = bind(speaker, "volume"),
        }),
      }),
      Widget.Button({
        on_click_release = function()
          speaker.mute = not speaker.mute
        end,
        Widget.Icon({
          class_name = "icon",
          icon = bind(speaker, "volume-icon"),
        }),
      }),
    }),
  })
end
