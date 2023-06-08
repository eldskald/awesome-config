local awful = require('awful')
local beautiful = require('beautiful')

-- Handling clients
client.connect_signal('manage', function(c)
  if not awesome.startup then
    awful.client.setslave(c)
  end
  if
    awesome.startup
    and not c.size_hints.user_position
    and not c.size_hints.program_position
  then
    awful.placement.no_offscreen(c)
  end
end)

-- Focus a new client when closing one
require('awful.autofocus')

-- Focus a client when hovering with mouse
client.connect_signal('mouse::enter', function(c)
  c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)

-- Reload config when screen geometry changes
screen.connect_signal('property::geometry', awesome.restart)

-- Rules
local keys = require('system.keybinds')
awful.rules.rules = {
  {
    rule = {},
    properties = {
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal,
      callback = awful.client.setslave,
      focus = awful.client.focus.filter,
      raise = true,
      keys = keys.clientkeys,
      buttons = keys.clientbuttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen + awful.placement.no_overlap,
      size_hints_honor = false
    }
  }
}
