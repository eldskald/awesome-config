local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

-- This file's return table
local keys = {}

-- Mod key definition
local modkey = 'Mod4'

-- Movement function
local function move_client(c, direction)
  if
    c.floating or (awful.layout.get(mouse.screen) == awful.layout.suit.floating)
  then
    local workarea = awful.screen.focused().workarea
    if direction == 'up' then
      c:geometry({ nil, y = workarea.y + beautiful.useless_gap * 2, nil, nil })
    elseif direction == 'down' then
      c:geometry({
        nil,
        y = workarea.height
          + workarea.y
          - c:geometry().height
          - beautiful.useless_gap * 2
          - beautiful.border_width * 2,
        nil,
        nil,
      })
    elseif direction == 'left' then
      c:geometry({ x = workarea.x + beautiful.useless_gap * 2, nil, nil, nil })
    elseif direction == 'right' then
      c:geometry({
        x = workarea.width
          + workarea.x
          - c:geometry().width
          - beautiful.useless_gap * 2
          - beautiful.border_width * 2,
        nil,
        nil,
        nil,
      })
    end
  elseif awful.layout.get(mouse.screen) == awful.layout.suit.max then
    if direction == 'up' or direction == 'left' then
      awful.client.swap.byidx(-1, c)
    elseif direction == 'down' or direction == 'right' then
      awful.client.swap.byidx(1, c)
    end
  else
    awful.client.swap.bydirection(direction, c, nil)
  end
end

-- Resize client in given direction
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

local function resize_client(c, direction)
  if
    awful.layout.get(mouse.screen) == awful.layout.suit.floating
    or (c and c.floating)
  then
    if direction == 'up' then
      c:relative_move(0, 0, 0, -floating_resize_amount)
    elseif direction == 'down' then
      c:relative_move(0, 0, 0, floating_resize_amount)
    elseif direction == 'left' then
      c:relative_move(0, 0, -floating_resize_amount, 0)
    elseif direction == 'right' then
      c:relative_move(0, 0, floating_resize_amount, 0)
    end
  else
    if direction == 'up' then
      awful.client.incwfact(-tiling_resize_factor)
    elseif direction == 'down' then
      awful.client.incwfact(tiling_resize_factor)
    elseif direction == 'left' then
      awful.tag.incmwfact(-tiling_resize_factor)
    elseif direction == 'right' then
      awful.tag.incmwfact(tiling_resize_factor)
    end
  end
end

-- raise focused client
local function raise_client()
  if client.focus then
    client.focus:raise()
  end
end

-- Mouse bindings
keys.desktopbuttons = gears.table.join(awful.button({}, 1, function()
  naughty.destroy_all_notifications()
end))
keys.clientbuttons = gears.table.join(
  awful.button({}, 1, function(c)
    client.focus = c
    c:raise()
  end),
  awful.button({ modkey }, 1, awful.mouse.client.move),
  awful.button({ modkey }, 3, awful.mouse.client.resize)
)

keys.globalkeys = gears.table.join(

  -- System
  awful.key(
    { modkey },
    'z',
    hotkeys_popup.show_help,
    { description = 'help', group = 'system' }
  ),

  awful.key(
    { modkey, 'Shift' },
    'r',
    awesome.restart,
    { description = 'reload awesome', group = 'system' }
  ),

  awful.key({ modkey }, 'Escape', function()
    awesome.emit_signal('show_exit_screen')
  end, { description = 'toggle exit screen', group = 'system' }),

  awful.key({}, 'XF86PowerOff', function()
    awesome.emit_signal('show_exit_screen')
  end, { description = 'toggle exit screen', group = 'system' }),

  -- Launchers
  awful.key({ modkey }, 'Return', function()
    awful.spawn(apps.terminal)
  end, { description = 'open a terminal', group = 'launcher' }),
  awful.key({ modkey }, 'd', function()
    awful.spawn(apps.launcher)
  end, { description = 'application launcher', group = 'launcher' }),
  awful.key({ modkey }, 'w', function()
    awful.spawn(apps.web_browser)
  end, { description = 'launch web browser', group = 'launcher' }),
  awful.key({ modkey, 'Shift' }, 'w', function()
    awful.spawn(apps.web_browser .. ' --incognito')
  end, { description = 'launch web browser incognito', group = 'launcher' }),
  awful.key({ modkey }, 'e', function()
    awful.spawn(
      [[kitty zsh -c "NNN_FIFO='/tmp/nnn.fifo' NNN_TRASH=1 NNN_PLUG='p:preview-tui;j:autojump;f:fzcd;d:dragdrop' nnn -eHPp"]]
    )
  end, { description = 'launch file browser', group = 'launcher' }),
  awful.key({ modkey }, 'x', function()
    awful.spawn(apps.terminal .. ' nvim -c \'bd\'')
  end, { description = 'launch notepad', group = 'launcher' }),
  awful.key({ modkey }, 'c', function()
    awful.spawn(apps.terminal .. ' bc')
  end, { description = 'launch calculator', group = 'launcher' })
)

return keys
