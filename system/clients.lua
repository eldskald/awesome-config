local awful = require('awful')

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
