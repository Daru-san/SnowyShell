local astal = require("astal")
local bind = astal.bind
local Variable = astal.Variable
local Widget = require("astal.gtk3.widget")

local Mpris = astal.require("AstalMpris")
local mpris = Mpris.get_default()

local is_revealed = Variable()

local MusicLabel = function(player)
  return Widget.Box({
    Widget.Label({
      label = bind(player, "metadata"):as(function()
        return (player.title or "") .. " - " .. (player.artist or "")
      end),
    }),
  })
end

return function()
  return Widget.EventBox({
    on_hover = function()
      is_revealed:set(true)
    end,
    on_hover_lost = function()
      is_revealed:set(false)
    end,
    Widget.Box({
      bind(mpris, "players"):as(function(players)
        local player = players[1]
        return Widget.Box({
          class_name = "Media",
          Widget.Box({
            class_name = "Cover",
            valign = "CENTER",
            css = bind(player, "cover-art"):as(function(cover)
              return "background-image: url('" .. (cover or "") .. "');"
            end),
          }),
          Widget.Revealer({
            reveal_child = is_revealed(),
            transition_type = "SLIDE_LEFT",
            valign = "CENTER",
            MusicLabel(player),
          }),
        })
      end),
    }),
  })
end
