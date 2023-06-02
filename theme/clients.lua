local beautiful = require('beautiful')
local awful = require('awful')
local wibox = require('wibox')
local table = awful.util.table

-- Gaps
beautiful.useless_cap = 8
beautiful.gap_single_client = true

-- Disable titlebars by default
client.connect_signal('manage', function(c)
  awful.titlebar.hide(c)
end)

-- Titlebar settings
client.connect_signal('request::titlebars', function(c)
  -- Custom
  if beautiful.titlebar_fun then
    beautiful.titlebar_fun(c)
    return
  end

  -- Default
  -- buttons for the titlebar
  local buttons = table.join(
    awful.button({}, 1, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.move(c)
    end),
    awful.button({}, 3, function()
      c:emit_signal('request::activate', 'titlebar', { raise = true })
      awful.mouse.client.resize(c)
    end)
  )

  awful.titlebar(c, { size = 16 }):setup({
    {
      -- Left
      awful.titlebar.widget.iconwidget(c),
      buttons = buttons,
      layout = wibox.layout.fixed.horizontal,
    },
    {
      -- Middle
      {
        -- Title
        align = 'center',
        widget = awful.titlebar.widget.titlewidget(c),
      },
      buttons = buttons,
      layout = wibox.layout.flex.horizontal,
    },
    {
      -- Right
      awful.titlebar.widget.floatingbutton(c),
      awful.titlebar.widget.maximizedbutton(c),
      awful.titlebar.widget.stickybutton(c),
      awful.titlebar.widget.ontopbutton(c),
      awful.titlebar.widget.closebutton(c),
      layout = wibox.layout.fixed.horizontal(),
    },
    layout = wibox.layout.align.horizontal,
  })
end)
