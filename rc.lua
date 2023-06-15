-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, 'luarocks.loader')

local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
local wibox = require('wibox')
local beautiful = require('beautiful')
local naughty = require('naughty')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')
local dpi = beautiful.xresources.apply_dpi

-- Load Debian menu entries
local debian = require('debian.menu')
local has_fdo, freedesktop = pcall(require, 'freedesktop')

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset = naughty.config.presets.critical,
        title = 'Oops, there were errors during startup!',
        text = awesome.startup_errors,
    })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal('debug::error', function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then
            return
        end
        in_error = true

        naughty.notify({
            preset = naughty.config.presets.critical,
            title = 'Oops, an error happened!',
            text = tostring(err),
        })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_themes_dir() .. 'default/theme.lua')

-- This is used later as the default terminal and editor to run.
terminal = 'kitty'
editor = os.getenv('EDITOR') or 'nvim'
editor_cmd = terminal .. ' -e ' .. editor

-- Defining other default apps, for ease of change
web_browser = 'brave-browser'
file_browser = terminal
    .. ' sh -c '
    .. 'NNN_FIFO=\'/tmp/nnn.fifo\' '
    .. 'NNN_TRASH=1'
    .. 'NNN_PLUG=\'p:preview-tui;j:autojump;f:fzcd;d:dragdrop\' '
    .. 'nnn -eHPp'
notepad = terminal .. ' nvim -c "bd"'
calculator = terminal .. ' bc'
screenshot_tool = 'maim -s | xclip -selection clipboard -t image/png'

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = 'Mod4'

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.floating,
}
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
myawesomemenu = {
    {
        'hotkeys',
        function()
            hotkeys_popup.show_help(nil, awful.screen.focused())
        end,
    },
    { 'manual', terminal .. ' -e man awesome' },
    { 'edit config', editor_cmd .. ' ' .. awesome.conffile },
    { 'restart', awesome.restart },
    {
        'quit',
        function()
            awesome.quit()
        end,
    },
}

local menu_awesome = { 'awesome', myawesomemenu, beautiful.awesome_icon }
local menu_terminal = { 'open terminal', terminal }

if has_fdo then
    mymainmenu = freedesktop.menu.build({
        before = { menu_awesome },
        after = { menu_terminal },
    })
else
    mymainmenu = awful.menu({
        items = {
            menu_awesome,
            { 'Debian', debian.menu.Debian_menu.Debian },
            menu_terminal,
        },
    })
end

mylauncher = awful.widget.launcher({
    image = beautiful.awesome_icon,
    menu = mymainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t)
        awful.tag.viewnext(t.screen)
    end),
    awful.button({}, 5, function(t)
        awful.tag.viewprev(t.screen)
    end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal('request::activate', 'tasklist', { raise = true })
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end)
)

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == 'function' then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal('property::geometry', set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    awful.tag(
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        s,
        awful.layout.layouts[1]
    )

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 3, function()
            awful.layout.inc(-1)
        end),
        awful.button({}, 4, function()
            awful.layout.inc(1)
        end),
        awful.button({}, 5, function()
            awful.layout.inc(-1)
        end)
    ))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist({
        screen = s,
        filter = awful.widget.taglist.filter.all,
        buttons = taglist_buttons,
    })

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist({
        screen = s,
        filter = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
    })

    -- Create the wibox
    s.mywibox = awful.wibar({ position = 'top', screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup({
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mykeyboardlayout,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    })
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(
    gears.table.join(
        awful.button({}, 1, function()
            naughty.destroy_all_notifications()
        end),
        awful.button({}, 3, function()
            mymainmenu:toggle()
        end),
        awful.button({}, 4, awful.tag.viewnext),
        awful.button({}, 5, awful.tag.viewprev)
    )
)
-- }}}

-- raise focused client, for keybindings
local function raise_client()
    if client.focus then
        client.focus:raise()
    end
end

-- Resize client, for keybindings
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

-- Movement client in a given direction, for keybindings
local function move_client(c, direction)
    if
        c.floating
        or (awful.layout.get(mouse.screen) == awful.layout.suit.floating)
    then
        local workarea = awful.screen.focused().workarea
        if direction == 'up' then
            c:geometry({
                nil,
                y = workarea.y + beautiful.useless_gap * 2,
                nil,
                nil,
            })
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
            c:geometry({
                x = workarea.x + beautiful.useless_gap * 2,
                nil,
                nil,
                nil,
            })
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

-- {{{ Key bindings
globalkeys = gears.table.join(

    -- System
    awful.key(
        { modkey },
        'z',
        hotkeys_popup.show_help,
        { description = 'help', group = 'system' }
    ),
    awful.key({ modkey }, 'r', function()
        awful.screen.focused().mypromptbox:run()
    end, { description = 'run prompt', group = 'system' }),
    awful.key(
        { modkey, 'Shift' },
        'r',
        awesome.restart,
        { description = 'reload awesome wm', group = 'system' }
    ),
    awful.key({ modkey }, 'Escape', function()
        awesome.emit_signal('show_exit_screen')
    end, { description = 'toggle exit screen', group = 'system' }),
    awful.key({}, 'XF86PowerOff', function()
        awesome.emit_signal('show_exit_screen')
    end, { description = 'toggle exit screen', group = 'system' }),
    awful.key({}, 'Print', function()
        os.execute(screenshot_tool)
    end, { description = 'take a screenshot', group = 'system' }),

    -- Launchers
    awful.key({ modkey }, 'Return', function()
        awful.spawn(terminal)
    end, { description = 'open a terminal', group = 'launcher' }),
    awful.key({ modkey }, 'd', function()
        awful.spawn('rofi -modi drun -show drun')
    end, { description = 'application launcher', group = 'launcher' }),
    awful.key({ modkey }, 'w', function()
        awful.spawn(web_browser)
    end, { description = 'launch web browser', group = 'launcher' }),
    awful.key({ modkey, 'Shift' }, 'w', function()
        awful.spawn(web_browser .. ' --incognito')
    end, { description = 'launch web browser incognito', group = 'launcher' }),
    awful.key({ modkey }, 'e', function()
        awful.spawn(file_browser)
    end, { description = 'launch file browser', group = 'launcher' }),
    awful.key({ modkey }, 'c', function()
        awful.spawn(calculator)
    end, { description = 'launch calculator', group = 'launcher' }),
    awful.key({ modkey }, 'x', function()
        awful.spawn(notepad)
    end, { description = 'launch notepad', group = 'launcher' }),
    awful.key({ modkey }, 'g', function()
        awful.spawn('steam')
    end, { description = 'launch steam', group = 'launcher' }),

    -- Focus client by direction with hjkl keys
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

    -- Focus client by index with tab key
    awful.key({ modkey }, 'Tab', function()
        awful.client.focus.byidx(1)
    end, { description = 'focus next by index', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'Tab', function()
        awful.client.focus.byidx(-1)
    end, { description = 'focus previous by index', group = 'client' }),

    -- Resize client
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

    -- Restore minimized clients
    awful.key({ modkey, 'Control' }, 'n', function()
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
    awful.key({ modkey }, 's', function()
        awful.screen.focus_relative(1)
    end, { description = 'focus next screen', group = 'screen' }),

    -- Layout manipulation
    awful.key({ modkey }, 'space', function()
        awful.layout.inc(1)
    end, { description = 'change layout', group = 'layout' }),
    awful.key({ modkey }, '=', function()
        awful.tag.incncol(1, nil, true)
    end, {
        description = 'increase the number of columns',
        group = 'layout',
    }),
    awful.key({ modkey }, '-', function()
        awful.tag.incncol(-1, nil, true)
    end, {
        description = 'decrease the number of columns',
        group = 'layout',
    })
)

clientkeys = gears.table.join(

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

    -- Move to next screen
    awful.key({ modkey, 'Shift' }, 's', function(c)
        c:move_to_screen()
    end, { description = 'move client to the next screen', group = 'screen' }),

    -- Client control
    awful.key({ modkey }, 'q', function(c)
        c:kill()
    end, { description = 'close', group = 'client' }),
    awful.key({ modkey }, 'f', function(c)
        c.fullscreen = not c.fullscreen
        c:raise()
    end, { description = 'toggle fullscreen', group = 'client' }),
    awful.key(
        { modkey, 'Control' },
        'f',
        awful.client.floating.toggle,
        { description = 'toggle floating', group = 'client' }
    ),
    awful.key({ modkey, 'Control' }, 't', function(c)
        c.ontop = not c.ontop
    end, { description = 'toggle keep on top', group = 'client' }),
    awful.key({ modkey }, 'n', function(c)
        c.minimized = true
    end, { description = 'minimize', group = 'client' }),
    awful.key({ modkey }, 'm', function(c)
        c.maximized = not c.maximized
        c:raise()
    end, { description = '(un)maximize', group = 'client' }),
    awful.key({ modkey, 'Control' }, 'm', function(c)
        c.maximized_vertical = not c.maximized_vertical
        c:raise()
    end, { description = '(un)maximize vertically', group = 'client' }),
    awful.key({ modkey, 'Shift' }, 'm', function(c)
        c.maximized_horizontal = not c.maximized_horizontal
        c:raise()
    end, { description = '(un)maximize horizontally', group = 'client' })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(
        globalkeys,
        -- View tag only.
        awful.key({ modkey }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                tag:view_only()
            end
        end, { description = 'view tag #' .. i, group = 'tag' }),
        -- Toggle tag display.
        awful.key({ modkey, 'Control' }, '#' .. i + 9, function()
            local screen = awful.screen.focused()
            local tag = screen.tags[i]
            if tag then
                awful.tag.viewtoggle(tag)
            end
        end, { description = 'toggle tag #' .. i, group = 'tag' }),
        -- Move client to tag.
        awful.key(
            { modkey, 'Shift' },
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
        awful.key({ modkey, 'Control', 'Shift' }, '#' .. i + 9, function()
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
clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal('request::activate', 'mouse_click', { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    {
        rule = {},
        properties = {
            border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap
                + awful.placement.no_offscreen,
        },
    },

    -- Floating clients.
    {
        rule_any = {
            instance = {
                'DTA', -- Firefox addon DownThemAll.
                'copyq', -- Includes session name in class.
                'pinentry',
            },
            class = {
                'Arandr',
                'Blueman-manager',
                'Gpick',
                'Kruler',
                'MessageWin', -- kalarm.
                'Sxiv',
                'Tor Browser', -- Needs a fixed window size to avoid fingerprinting by screen size.
                'Wpa_gui',
                'veromix',
                'xtightvncviewer',
            },

            -- Note that the name property shown in xprop might be set slightly after creation of the client
            -- and the name shown there might not match defined rules here.
            name = {
                'Event Tester', -- xev.
            },
            role = {
                'AlarmWindow', -- Thunderbird's calendar.
                'ConfigManager', -- Thunderbird's about:config.
                'pop-up', -- e.g. Google Chrome's (detached) Developer Tools.
            },
        },
        properties = { floating = true },
    },

    -- Add titlebars to normal clients and dialogs
    {
        rule_any = { type = { 'normal', 'dialog' } },
        properties = { titlebars_enabled = true },
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal('manage', function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if
        awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position
    then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal('request::titlebars', function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal('request::activate', 'titlebar', { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal('request::activate', 'titlebar', { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c):setup({
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

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal('mouse::enter', function(c)
    c:emit_signal('request::activate', 'mouse_enter', { raise = false })
end)

client.connect_signal('focus', function(c)
    c.border_color = beautiful.border_focus
end)
client.connect_signal('unfocus', function(c)
    c.border_color = beautiful.border_normal
end)
-- }}}
