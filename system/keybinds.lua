local awful = require('awful')
local hotkeys_popup = require('awful.hotkeys_popup')
local gears = require('gears')
local naughty = require('naughty')
local beautiful = require('beautiful')
local dpi = beautiful.xresources.apply_dpi

local apps = require('default_apps')

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

  awful.key({}, 'Print', function()
    os.execute(apps.screenshot)
  end, { description = 'take a screenshot', group = 'system' }),

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

  awful.key({ modkey }, 'e', function()
    awful.spawn(apps.file_browser)
  end, { description = 'launch file browser', group = 'launcher' }),

  -- Client

  -- Client control
  awful.key({ modkey }, 'f', function(c)
    c.fullscreen = not c.fullscreen
  end, { description = 'toggle fullscreen', group = 'client' }),

  awful.key({ modkey }, 'q', function(c)
    c:kill()
  end, { description = 'close', group = 'client' }),

  awful.key({ modkey }, 'm', function(c)
    c.maximized = not c.maximized
    c:raise()
  end, { description = '(un)maximize', group = 'client' }),

  awful.key({ modkey }, 'n', function(c)
    c.minimized = true
  end, { description = 'minimize', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'n', function()
    local c = awful.client.restore()
    if c then
      client.focus = c
      c:raise()
    end
  end, { description = 'restore minimized', group = 'client' }),

  -- Focus client by hjkl keys
  awful.key({ modkey }, 'j', function()
    awful.client.focus.bydirection('down')
    raise_client()
  end, { description = 'focus down', group = 'client' }),

  awful.key({ modkey }, 'k', function()
    awful.client.focus.bydirection('up')
    raise_client()
  end, { description = 'focus up', group = 'client' }),

  awful.key({ modkey }, 'h', function()
    awful.client.focus.bydirection('left')
    raise_client()
  end, { description = 'focus left', group = 'client' }),

  awful.key({ modkey }, 'l', function()
    awful.client.focus.bydirection('right')
    raise_client()
  end, { description = 'focus right', group = 'client' }),

  -- Focus client by arrow keys
  awful.key({ modkey }, 'Down', function()
    awful.client.focus.bydirection('down')
    raise_client()
  end, { description = 'focus down', group = 'client' }),

  awful.key({ modkey }, 'Up', function()
    awful.client.focus.bydirection('up')
    raise_client()
  end, { description = 'focus up', group = 'client' }),

  awful.key({ modkey }, 'Left', function()
    awful.client.focus.bydirection('left')
    raise_client()
  end, { description = 'focus left', group = 'client' }),

  awful.key({ modkey }, 'Right', function()
    awful.client.focus.bydirection('right')
    raise_client()
  end, { description = 'focus right', group = 'client' }),

  -- Focus client by index (cycle through clients)
  awful.key({ modkey }, 'Tab', function()
    awful.client.focus.byidx(1)
  end, { description = 'focus next by index', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'Tab', function()
    awful.client.focus.byidx(-1)
  end, { description = 'focus previous by index', group = 'client' }),

  -- Resize client by hjkl keys
  awful.key({ modkey, 'Control' }, 'j', function()
    resize_client(client.focus, 'down')
  end, { description = 'resize client down', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'k', function()
    resize_client(client.focus, 'up')
  end, { description = 'resize client up', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'h', function()
    resize_client(client.focus, 'left')
  end, { description = 'resize client left', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'l', function()
    resize_client(client.focus, 'right')
  end, { description = 'resize client right', group = 'client' }),

  -- Resize client by arrow keys
  awful.key({ modkey, 'Control' }, 'Down', function()
    resize_client(client.focus, 'down')
  end, { description = 'resize client down', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'Up', function()
    resize_client(client.focus, 'up')
  end, { description = 'resize client up', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'Left', function()
    resize_client(client.focus, 'left')
  end, { description = 'resize client left', group = 'client' }),

  awful.key({ modkey, 'Control' }, 'Right', function()
    resize_client(client.focus, 'right')
  end, { description = 'resize client right', group = 'client' }),

  -- Move client by hjkl keys
  awful.key({ modkey, 'Shift' }, 'j', function(c)
    move_client(c, 'down')
  end, { description = 'move client down', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'k', function(c)
    move_client(c, 'up')
  end, { description = 'move client up', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'h', function(c)
    move_client(c, 'left')
  end, { description = 'move client right', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'l', function(c)
    move_client(c, 'right')
  end, { description = 'move client left', group = 'client' }),

  -- Move client by arrow keys
  awful.key({ modkey, 'Shift' }, 'Down', function(c)
    move_client(c, 'down')
  end, { description = 'move client down', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'Up', function(c)
    move_client(c, 'up')
  end, { description = 'move client up', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'Left', function(c)
    move_client(c, 'left')
  end, { description = 'move client left', group = 'client' }),

  awful.key({ modkey, 'Shift' }, 'Right', function(c)
    move_client(c, 'right')
  end, { description = 'move client right', group = 'client' }),

  -- Focus next screen
  awful.key({ modkey }, 's', function()
    awful.screen.focus_relative(1)
  end, { description = 'focus next screen' }),

  -- Move to next screen
  awful.key({ modkey, 'Shift' }, 's', function(c)
    c:move_to_screen()
  end, { description = 'move to next screen', group = 'client' })
)

root.keys(keys.globalkeys)
root.buttons(keys.desktopbuttons)
