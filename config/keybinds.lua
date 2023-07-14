local gears = require('gears')
local awful = require('awful')
local naughty = require('naughty')
local beautiful = require('beautiful')
local hotkeys_popup = require('awful.hotkeys_popup')
local dpi = beautiful.xresources.apply_dpi

local defs = require('config.defs')
local right_click_menu = require('config.right-click-menu')

local keybinds = {}

-- Raise focused client
function raise_client()
    if client.focus then
        client.focus:raise()
    end
end

-- Resize client
local floating_resize_amount = dpi(20)
local tiling_resize_factor = 0.05

function resize_client(c, direction)
    if
        awful.layout.get(c.screen) == awful.layout.suit.floating
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

-- Movement client in a given direction
local floating_move_speed = dpi(20)
function move_client(c, direction)
    if
        c.floating
        or (awful.layout.get(c.screen) == awful.layout.suit.floating)
    then
        if direction == 'up' then
            c.y = c.y - floating_move_speed
        elseif direction == 'down' then
            c.y = c.y + floating_move_speed
        elseif direction == 'left' then
            c.x = c.x - floating_move_speed
        elseif direction == 'right' then
            c.x = c.x + floating_move_speed
        end
    elseif awful.layout.get(c.screen) == awful.layout.suit.max then
        if direction == 'up' or direction == 'left' then
            awful.client.swap.byidx(-1, c)
        elseif direction == 'down' or direction == 'right' then
            awful.client.swap.byidx(1, c)
        end
    else
        awful.client.swap.bydirection(direction, c, nil)
    end
end

-- Key bindings
keybinds.globalkeys = gears.table.join(

    -- System
    awful.key(
        { defs.modkey },
        'z',
        hotkeys_popup.show_help,
        { description = 'help', group = 'system' }
    ),
    awful.key({ defs.modkey }, 'r', function()
        awful.screen.focused().mypromptbox:run()
    end, { description = 'run prompt', group = 'system' }),
    awful.key(
        { defs.modkey, 'Shift' },
        'r',
        awesome.restart,
        { description = 'reload awesome wm', group = 'system' }
    ),
    awful.key({ defs.modkey }, 'Escape', function()
        awesome.emit_signal('show_exit_screen')
    end, { description = 'toggle exit screen', group = 'system' }),
    awful.key({}, 'XF86PowerOff', function()
        awesome.emit_signal('show_exit_screen')
    end, { description = 'toggle exit screen', group = 'system' }),
    awful.key({}, 'Print', function()
        os.execute(defs.screenshot_tool)
    end, { description = 'take a screenshot', group = 'system' }),

    -- Launchers
    awful.key({ defs.modkey }, 'Return', function()
        awful.spawn(defs.terminal)
    end, { description = 'open a terminal', group = 'launcher' }),
    awful.key({ defs.modkey }, 'd', function()
        awful.spawn('rofi -modi drun -show drun')
    end, { description = 'application launcher', group = 'launcher' }),
    awful.key({ defs.modkey }, 'w', function()
        awful.spawn(defs.web_browser)
    end, { description = 'launch web browser', group = 'launcher' }),
    awful.key({ defs.modkey, 'Shift' }, 'w', function()
        awful.spawn(defs.web_browser .. ' --incognito')
    end, { description = 'launch web browser incognito', group = 'launcher' }),
    awful.key({ defs.modkey }, 'c', function()
        awful.spawn(defs.code)
    end, { description = 'launch code console', group = 'launcher' }),
    awful.key({ defs.modkey }, 'x', function()
        awful.spawn(defs.text_editor)
    end, { description = 'launch text editor', group = 'launcher' }),
    awful.key({ defs.modkey }, 'g', function()
        awful.spawn(defs.games)
    end, { description = 'launch games', group = 'launcher' }),

    -- Focus client by direction with hjkl keys
    awful.key({ defs.modkey }, 'j', function()
        awful.client.focus.bydirection('down')
        raise_client()
    end, { description = 'focus down', group = 'client' }),
    awful.key({ defs.modkey }, 'k', function()
        awful.client.focus.bydirection('up')
        raise_client()
    end, { description = 'focus up', group = 'client' }),
    awful.key({ defs.modkey }, 'h', function()
        awful.client.focus.bydirection('left')
        raise_client()
    end, { description = 'focus left', group = 'client' }),
    awful.key({ defs.modkey }, 'l', function()
        awful.client.focus.bydirection('right')
        raise_client()
    end, { description = 'focus right', group = 'client' }),

    -- Focus client by index with tab key
    awful.key({ defs.modkey }, 'Tab', function()
        awful.client.focus.byidx(1)
    end, { description = 'focus next by index', group = 'client' }),
    awful.key({ defs.modkey, 'Shift' }, 'Tab', function()
        awful.client.focus.byidx(-1)
    end, { description = 'focus previous by index', group = 'client' }),

    -- Resize client
    awful.key({ defs.modkey, 'Control' }, 'j', function()
        resize_client(client.focus, 'down')
    end, { description = 'resize client down', group = 'client' }),
    awful.key({ defs.modkey, 'Control' }, 'k', function()
        resize_client(client.focus, 'up')
    end, { description = 'resize client up', group = 'client' }),
    awful.key({ defs.modkey, 'Control' }, 'h', function()
        resize_client(client.focus, 'left')
    end, { description = 'resize client left', group = 'client' }),
    awful.key({ defs.modkey, 'Control' }, 'l', function()
        resize_client(client.focus, 'right')
    end, { description = 'resize client right', group = 'client' }),

    -- Restore minimized clients
    awful.key({ defs.modkey, 'Control' }, 'n', function()
        local c = awful.client.restore()
        if c then
            c:emit_signal(
                'request::activate',
                'key.unminimize',
                { raise = true }
            )
        end
    end, { description = 'restore minimized', group = 'client' }),

    -- Focus next screen
    awful.key({ defs.modkey }, 's', function()
        awful.screen.focus_relative(1)
    end, { description = 'focus next screen', group = 'screen' }),

    -- Layout manipulation
    awful.key({ defs.modkey }, 'space', function()
        awful.layout.inc(1)
    end, { description = 'change layout', group = 'layout' }),
    awful.key({ defs.modkey }, '=', function()
        awful.tag.incncol(1, nil, true)
    end, {
        description = 'increase the number of columns',
        group = 'layout',
    }),
    awful.key({ defs.modkey }, '-', function()
        awful.tag.incncol(-1, nil, true)
    end, {
        description = 'decrease the number of columns',
        group = 'layout',
    })
)

keybinds.clientkeys = gears.table.join(

    -- Move client by hjkl keys
    awful.key({ defs.modkey, 'Shift' }, 'j', function(c)
        move_client(c, 'down')
    end, { description = 'move client down', group = 'client' }),
    awful.key({ defs.modkey, 'Shift' }, 'k', function(c)
        move_client(c, 'up')
    end, { description = 'move client up', group = 'client' }),
    awful.key({ defs.modkey, 'Shift' }, 'h', function(c)
        move_client(c, 'left')
    end, { description = 'move client right', group = 'client' }),
    awful.key({ defs.modkey, 'Shift' }, 'l', function(c)
        move_client(c, 'right')
    end, { description = 'move client left', group = 'client' }),

    -- Move to next screen
    awful.key({ defs.modkey, 'Shift' }, 's', function(c)
        c:move_to_screen()
    end, { description = 'move client to the next screen', group = 'screen' }),

    -- Client control
    awful.key({ defs.modkey }, 'q', function(c)
        c:kill()
    end, { description = 'close', group = 'client' }),
    awful.key({ defs.modkey }, 'f', function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = 'toggle fullscreen', group = 'client' }),
    awful.key({ defs.modkey }, 't', function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.floating then
            if c.floating then
                c.floating = false
            else
                c.floating = true
                local area = c.screen.workarea
                c.width = area.width * 0.6
                c.height = area.height * 0.6
                c.x = area.width * 0.2
                c.y = area.height * 0.2
            end
        end
    end, { description = 'toggle floating', group = 'client' }),
    awful.key({ defs.modkey, 'Control' }, 't', function(c)
        c.ontop = not c.ontop
    end, { description = 'toggle keep on top', group = 'client' }),
    awful.key({ defs.modkey }, 'n', function(c)
        c.minimized = true
    end, { description = 'minimize', group = 'client' }),
    awful.key({ defs.modkey }, 'm', function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = '(un)maximize', group = 'client' }),
    awful.key({ defs.modkey, 'Control' }, 'm', function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = '(un)maximize vertically', group = 'client' }),
    awful.key({ defs.modkey, 'Shift' }, 'm', function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = '(un)maximize horizontally', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    keybinds.globalkeys = gears.table.join(
        keybinds.globalkeys,

        -- View tag only.
        awful.key({ defs.modkey }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = 'view tag #' .. i, group = 'tag' }),

        -- Toggle tag display.
        awful.key({ defs.modkey, 'Control' }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = 'toggle tag #' .. i, group = 'tag' }),

        -- Move client to tag.
        awful.key(
            { defs.modkey, 'Shift' },
            '#' .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            { description = 'move focused client to tag #' .. i, group = 'tag' }
        ),

        -- Toggle tag on focused client.
        awful.key({ defs.modkey, 'Control', 'Shift' }, '#' .. i + 9, function()
            if client.focus then
                local tag = client.focus.screen.tags[i]
                if tag then
                    client.focus:toggle_tag(tag)
                end
            end
        end, {
            description = 'toggle focused client on tag #' .. i,
            group = 'tag',
        })
    )
end

-- Mouse bindings
keybinds.globalbuttons = gears.table.join(
    awful.button({}, 1, function()
        naughty.destroy_all_notifications()
    end),
    awful.button({}, 3, right_click_menu),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
)

keybinds.clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    awful.button({ defs.modkey }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ defs.modkey }, 3, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.resize(c)
    end)
)

return keybinds
