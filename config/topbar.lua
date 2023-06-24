local awful = require('awful')
local gears = require('gears')
local wibox = require('wibox')
local beautiful = require('beautiful')
local menubar = require('menubar')
local hotkeys_popup = require('awful.hotkeys_popup')
local dpi = beautiful.xresources.apply_dpi

local defs = require('config.defs')
local theme = require('config.theme')

menubar.utils.terminal = defs.terminal

-- Main menu widget
local main_menu = wibox.container.margin(
    awful.widget.launcher({
        image = beautiful.awesome_icon,
        menu = awful.menu({
            items = {
                {
                    '  Open Terminal',
                    function()
                        awful.spawn(defs.terminal)
                    end,
                },
                {
                    '󰘥  Keybindings',
                    function()
                        hotkeys_popup.show_help(nil, awful.screen.focused())
                    end,
                },
                { '󱚋  Manual', defs.terminal .. ' -e man awesome' },
                { '󰑓  Reload', awesome.restart },
                {
                    '󰍃  Logout',
                    function()
                        awesome.quit()
                    end,
                },
                {
                    '󰏤  Suspend',
                    function()
                        os.execute('systemctl suspend')
                    end,
                },
                {
                    '  Restart',
                    function()
                        os.execute('systemctl reboot')
                    end,
                },
                {
                    '  Power Off',
                    function()
                        os.execute('systemctl poweroff')
                    end,
                },
            },
        }),
    }),
    dpi(8),
    dpi(8),
    dpi(8),
    dpi(8)
)
-- Keyboard map indicator and switcher
-- local keyboardlayout = wibox.container.margin(
--     awful.widget.keyboardlayout(),
--     dpi(8),
--     dpi(8),
--     dpi(8),
--     dpi(8)
-- )

-- Time widget
local calendar_widget = require('widgets.calendar-widget.calendar')
local time = wibox.container.margin(
    wibox.widget.textclock(),
    dpi(8),
    dpi(8),
    dpi(8),
    dpi(8)
)
calendar_widget({ placement = 'top_right' })
time:connect_signal('button::press', function(_, _, _, button)
    if button == 1 then
        calendar_widget.toggle()
    end
end)

-- Battery widget
local battery_widget = require('widgets.battery-widget.battery')
local battery = wibox.container.margin(
    battery_widget({
        font = theme.font,
        enable_battery_warning = false,
        show_current_level = true,
    }),
    dpi(8),
    dpi(8),
    dpi(8),
    dpi(8)
)

-- Volume widget
local volume_widget = require('widgets.volume-widget.volume')
local volume = wibox.container.margin(
    volume_widget({
        widget_type = 'icon_and_text',
    }),
    dpi(8),
    dpi(8),
    dpi(8),
    dpi(8)
)

-- Brightness widget
local brightness_widget = require('widgets.brightness-widget.brightness')
local brightness = wibox.container.margin(
    brightness_widget({
        type = 'icon_and_text',
        program = 'brightnessctl',
        percentage = false,
        step = 2,
    }),
    dpi(8),
    dpi(8),
    dpi(8),
    dpi(8)
)

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t)
        t:view_only()
    end),
    awful.button({ defs.modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ defs.modkey }, 3, function(t)
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

awful.screen.connect_for_each_screen(function(s)
    -- Tags
    awful.tag(
        { '1', '2', '3', '4', '5', '6', '7', '8', '9' },
        s,
        awful.layout.layouts[1]
    )
    s.mytaglist = wibox.container.margin(
        awful.widget.taglist({
            screen = s,
            filter = awful.widget.taglist.filter.all,
            buttons = taglist_buttons,
        }),
        dpi(8),
        dpi(8),
        dpi(8),
        dpi(8)
    )

    -- Run prompt
    s.mypromptbox = awful.widget.prompt()

    -- Layout box
    s.mylayoutbox = wibox.container.margin(
        awful.widget.layoutbox(s),
        dpi(8),
        dpi(8),
        dpi(8),
        dpi(8)
    )
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

    s.mytasklist = wibox.container.margin(
        awful.widget.tasklist({
            screen = s,
            filter = awful.widget.tasklist.filter.currenttags,
            buttons = tasklist_buttons,
        }),
        dpi(8),
        dpi(8),
        dpi(8),
        dpi(8)
    )

    -- Topbar setup
    s.padding = awful.wibar({
        screen = s,
        height = 2 * theme.useless_gap,
        bg = '#00000000',
    })
    s.topbar = awful.wibar({
        screen = s,
        ontop = true,
        height = dpi(40),
        width = s.geometry.width - 4 * theme.useless_gap,
        fg = theme.fg_color,
        bg = theme.bg_color,
        opacity = theme.opacity,
    })
    s.topbar:setup({
        layout = wibox.layout.align.horizontal,
        {
            -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            main_menu,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        {
            -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            time,
            brightness,
            volume,
            battery,
            s.mylayoutbox,
        },
    })
end)
